Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95687366621
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 09:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235384AbhDUHSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 03:18:41 -0400
Received: from bakdmz.coruna.es ([212.51.63.63]:32779 "EHLO bakdmz.coruna.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232194AbhDUHSk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Apr 2021 03:18:40 -0400
X-Greylist: delayed 526 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Apr 2021 03:18:40 EDT
Received: from mail.manty.net (unknown [212.14.115.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by bakdmz.coruna.es (Postfix) with ESMTPSA id 3F09E56A6;
        Wed, 21 Apr 2021 09:09:18 +0200 (CEST)
Received: by mail.manty.net (Postfix, from userid 1000)
        id E8A0F180079; Wed, 21 Apr 2021 09:09:14 +0200 (CEST)
Date:   Wed, 21 Apr 2021 09:09:14 +0200
From:   Santiago Garcia Mantinan <manty@debian.org>
To:     Shyam Prasad <Shyam.Prasad@microsoft.com>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        pc <pc@cjr.nz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Aurelien Aptel <aaptel@suse.com>,
        Steven French <Steven.French@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH 4.19 013/247] cifs: Set
 CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
Message-ID: <YH/Pmn7iH5f+stbg@mail.manty.net>
References: <20210301161031.684018251@linuxfoundation.org>
 <20210301161032.337414143@linuxfoundation.org>
 <YGxIMCsclG4E1/ck@eldamar.lan>
 <YGxlJXv/+IPaErUr@kroah.com>
 <PSAP153MB04220682838AC9D025414B6094769@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
 <YGx3u01Wa/DDnjlV@eldamar.lan>
 <YG7r0UaivWZL762N@eldamar.lan>
 <YHP+XbVWfGv21EL1@kroah.com>
 <YHwo5prs4MbXEzER@eldamar.lan>
 <PSAP153MB04224202F4A2BE668533F94794499@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PSAP153MB04224202F4A2BE668533F94794499@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

On Abr 19 2021, Shyam Prasad wrote:
> Hi Salvatore,
> 
> Attached is a proposed fix from Paulo for older kernels. 
> Can you please confirm that this works for you too? 

Salvatore pinged me for some tests on this, I did apply this patch on top of
Debian's 4.19.181-1 which was failing and it now works as expected.

Regards.
-- 
Manty/BestiaTester -> http://manty.net
