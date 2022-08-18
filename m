Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE961598316
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 14:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240115AbiHRMXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 08:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244363AbiHRMXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 08:23:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD1513DD6;
        Thu, 18 Aug 2022 05:23:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE950B81BAF;
        Thu, 18 Aug 2022 12:23:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FEDC433C1;
        Thu, 18 Aug 2022 12:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660825426;
        bh=ml7eXjeRyl8dL+/I57p7KaIbiXhd9wl2AAo7NY7lNj8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LZS9G7D2LcZCm33CkMOb/ps/AtPRn5Ph1amlq6GRPqjnNPA2w52LN2HjQ2Pw1LoWn
         m0gzB1vhXL1eSPwjrI1iEZmBOsfKS76l/On2AqGCVpLdlr4AOhgEE5b76EkmLQih5K
         h1zIOfmIAKEF7K5y3rotcAjJlETScPynfit418o8=
Date:   Thu, 18 Aug 2022 14:23:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kbuild@vger.kernel.org, live-patching@vger.kernel.org,
        lkp@intel.com, stable@vger.kernel.org
Subject: Re: [RFC PATCH 3/3] kallsyms: add option to include relative
 filepaths into kallsyms
Message-ID: <Yv4vT6s6UHYvXOlX@kroah.com>
References: <20220818115306.1109642-1-alexandr.lobakin@intel.com>
 <20220818115306.1109642-4-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818115306.1109642-4-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 18, 2022 at 01:53:06PM +0200, Alexander Lobakin wrote:
> Currently, kallsyms kernel code copes with symbols with the same
> name by indexing them according to their position in vmlinux and
> requiring to provide an index of the desired symbol. This is not
> really quite reliable and is fragile to any features performing
> symbol or section manipulations such as FG-KASLR.

Ah, here's the reasoning, stuff like this should go into the 0/X message
too, right?

Anyway, what is currently broken that requires this?  What will this
make easier in the future?  What in the future will depend on this?

> So, in order to make kallsyms immune to object code modification

What do you mean by "object code modification"?

Can that happen now?  What causes it?  What happens if it does happen?

And why are any of these being cc:ed to the stable mailing list?

confused,

greg k-h
