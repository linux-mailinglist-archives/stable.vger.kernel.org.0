Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D643645EE
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 16:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239338AbhDSOXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 10:23:07 -0400
Received: from mx.cjr.nz ([51.158.111.142]:21468 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238543AbhDSOXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 10:23:07 -0400
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Apr 2021 10:23:06 EDT
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id B616F7FD55;
        Mon, 19 Apr 2021 14:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1618841782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fA+NVHpPNt+mbGbp4OrvXUgPN02dmtMDQMSKbCrIK5U=;
        b=vu5p+dmWMnrEtF6dI46CkFTnvDisCKpCoj+YGFyDsfNfX2NUzLKfkhBV4/B/FpXwkVLi20
        d6/JXnNSXy6Iajp3PZgNgdY2E4OH9T90Pg6khz3eXaBSSc1ResoPFvp1QwCb8dRU/hH4nU
        KHIFk2POLb2ZdzgBi7b99RVdh8gVcNCoTm+CwHlyOIjPzuuSXBI7G/uB4AhyR4E8UlT50s
        9KA9VyE4vKnpLoOBj9kigCB65z7I+J433waxJcNSIkRNgf+pJP6DBAU2a5UrqTmd0xjStp
        SEttBOytgQiUBllyF65dnuQq54tcb64fovz57AbAQ0YidvXpFf2cCJ7+G8gUvg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Salvatore Bonaccorso <carnil@debian.org>,
        Shyam Prasad <Shyam.Prasad@microsoft.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Aurelien Aptel <aaptel@suse.com>,
        Steven French <Steven.French@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH 4.19 013/247] cifs: Set
 CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
In-Reply-To: <YH2EBzOKkg4kGoQn@eldamar.lan>
References: <20210301161031.684018251@linuxfoundation.org>
 <20210301161032.337414143@linuxfoundation.org>
 <YGxIMCsclG4E1/ck@eldamar.lan> <YGxlJXv/+IPaErUr@kroah.com>
 <PSAP153MB04220682838AC9D025414B6094769@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
 <YGx3u01Wa/DDnjlV@eldamar.lan> <YG7r0UaivWZL762N@eldamar.lan>
 <YHP+XbVWfGv21EL1@kroah.com> <YHwo5prs4MbXEzER@eldamar.lan>
 <PSAP153MB04224202F4A2BE668533F94794499@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
 <YH2EBzOKkg4kGoQn@eldamar.lan>
Date:   Mon, 19 Apr 2021 11:16:27 -0300
Message-ID: <875z0i9x6s.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Salvatore Bonaccorso <carnil@debian.org> writes:

> So just to be clear, first apply again a738c93fb1c1 and then your
> additional patch on top?

Yes.
