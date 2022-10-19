Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12DD1604267
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbiJSLBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234834AbiJSLBX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:01:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E1415DB38;
        Wed, 19 Oct 2022 03:30:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BE8AB822C8;
        Wed, 19 Oct 2022 10:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71935C433C1;
        Wed, 19 Oct 2022 10:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666175328;
        bh=w/IbcFExb1CG7kPAuQOgXPWAylkOleczpwhIpQwM1ug=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BiyAP5vLS57K3vzZHTQn52ireMZcxTypPtwIrSK9TstiIs3E+5MOdHgHHoRk2HNXG
         c41bBKXly5tGbtHZkMw5llUhvT2s+3TLy4wobpAAhnRrs4K1dfj0EeQxmLOANDa3yq
         6Alz/3nsjgVSPSpeXr6t16tm/Bh3ikH1umJ1IjUI=
Date:   Wed, 19 Oct 2022 12:28:46 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        bpf@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Philip =?iso-8859-1?Q?M=FCller?= <philm@manjaro.org>
Subject: Re: [PATCH stable 5.10 2/5] kbuild: Quote OBJCOPY var to avoid a
 pahole call break the build
Message-ID: <Y0/RXjwt6y1Dfh9y@kroah.com>
References: <20221019085604.1017583-1-jolsa@kernel.org>
 <20221019085604.1017583-3-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019085604.1017583-3-jolsa@kernel.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 10:56:01AM +0200, Jiri Olsa wrote:
> From: Javier Martinez Canillas <javierm@redhat.com>
> 
> commit ff2e6efda0d5c51b33e2bcc0b0b981ac0a0ef214 upstream.

I only see patches 2, 3, and 4 of this series, same with
lore.kernel.org:
	https://lore.kernel.org/all/20221019085604.1017583-3-jolsa@kernel.org/

Are the remaining ones somewhere else?

thanks,

greg k-h
