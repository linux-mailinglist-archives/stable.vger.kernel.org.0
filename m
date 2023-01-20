Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5042067484F
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 01:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjATAvh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Jan 2023 19:51:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjATAvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Jan 2023 19:51:35 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC40B773;
        Thu, 19 Jan 2023 16:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=C+qYuMaNSBRYpklV0ttp1/UWpWnQ6DrhHlqrvIq2oTE=; b=2KGz+AMKleV593cjIa7PLXSQdm
        GE5zd4lmIh527ER4jJZFDU5/uNCgOn+8tleQ4hcwE+NuozvKf8sK1a0k5KzWPuFp5SVQ8iaadanso
        gpDMivtkUMeFN7AsEhUWquEjoQaUdQt0rUTK14sOttsG5mHrpfgJ2vvDMh/ntpyoD2EGWWWdJKe6k
        1RD5JAgSHOnI988KFRV0gbku0QSRKOlfKz9buAwE9kFo4OO7S+qwF0NHNLYdWpCcq1hezo7CYnlVF
        pNDSbkxf3ZvWA7VzdbItjQIq4Ece8DZYo+4yVTOr2Hsnf+acoRz+RO2hwQEeVFuQZqO+32CB7SPC+
        sV6Q14Dw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pIfct-007oR6-3D; Fri, 20 Jan 2023 00:51:27 +0000
Date:   Thu, 19 Jan 2023 16:51:27 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Petr Pavlu <petr.pavlu@suse.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Borislav Petkov <bp@alien8.de>, NeilBrown <neilb@suse.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>, david@redhat.com,
        mwilck@suse.com, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
Message-ID: <Y8nljyOJ5/y9Pp72@bombadil.infradead.org>
References: <20221205103557.18363-1-petr.pavlu@suse.com>
 <Y5gI/3crANzRv22J@bombadil.infradead.org>
 <Y5hRRnBGYaPby/RS@alley>
 <Y8c3hgVwKiVrKJM1@bombadil.infradead.org>
 <79aad139-5305-1081-8a84-42ef3763d4f4@suse.com>
 <Y8ll+eP+fb0TzFUh@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8ll+eP+fb0TzFUh@alley>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 19, 2023 at 04:47:05PM +0100, Petr Mladek wrote:
> Yes, the -EINVAL error is strange. It is returned also in
> kernel/module/main.c on few locations. But neither of them
> looks like a good candidate.

OK I updated to next-20230119 and I don't see the issue now.
Odd. It could have been an issue with next-20221207 which I was
on before.

I'll run some more test and if nothing fails I'll send the fix
to Linux for rc5.

  Luis
