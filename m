Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9FD5FBDF4
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 00:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiJKWuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 18:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiJKWt7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 18:49:59 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C14E016;
        Tue, 11 Oct 2022 15:49:54 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id EC3251F8B0;
        Tue, 11 Oct 2022 22:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1665528590; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u0K+tDxY91S4wQ9H7TDLz0f3SDpyKHNBEKeqLz2Ae3E=;
        b=sRgOJGXbQ4Y3bEg3wrJ7A91VzzgXRjufB+WWTXw8Fvy7noUoSGSDXSs6i+RP7FuuoQxyKM
        OZ42YOHiwgn+lb3fpKyHmerwrlfQ9fIIgtZgY+j3SIh+VCXYA53HRYuicgJBETxnjZzP7M
        HP/LiAFOy76J8FmaE7ocDvFjuRyLPpc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1665528590;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u0K+tDxY91S4wQ9H7TDLz0f3SDpyKHNBEKeqLz2Ae3E=;
        b=3kKi1MuqL0ir4LNRL+T46XoZVejEqg5Nos7qmaiO9BTUJUH92HmjoMulxxlooPVJx+Eiyc
        1ekIowgP/bfXWhCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9DB9C13AAC;
        Tue, 11 Oct 2022 22:49:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id kZXdJA7zRWMXDAAAMHmgww
        (envelope-from <jdelvare@suse.de>); Tue, 11 Oct 2022 22:49:50 +0000
Date:   Wed, 12 Oct 2022 00:49:49 +0200
From:   Jean Delvare <jdelvare@suse.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Chenglin Xu <chenglin.xu@mediatek.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 6.0 04/46] soc: mediatek: Let PMIC Wrapper and
 SCPSYS depend on OF
Message-ID: <20221012004949.06d45f74@endymion.delvare>
In-Reply-To: <20221011145015.1622882-4-sashal@kernel.org>
References: <20221011145015.1622882-1-sashal@kernel.org>
        <20221011145015.1622882-4-sashal@kernel.org>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Tue, 11 Oct 2022 10:49:32 -0400, Sasha Levin wrote:
> From: Jean Delvare <jdelvare@suse.de>
>=20
> [ Upstream commit 2778caedb5667239823a29148dfc48b26a8b3c2a ]
>=20
> With the following configuration options:
> CONFIG_OF is not set
> CONFIG_MTK_PMIC_WRAP=3Dy
> CONFIG_MTK_SCPSYS=3Dy
> we get the following build warnings:
>=20
>   CC      drivers/soc/mediatek/mtk-pmic-wrap.o
> drivers/soc/mediatek/mtk-pmic-wrap.c:2138:34: warning: =E2=80=98of_pwrap_=
match_tbl=E2=80=99 defined but not used [-Wunused-const-variable=3D]
> drivers/soc/mediatek/mtk-pmic-wrap.c:1953:34: warning: =E2=80=98of_slave_=
match_tbl=E2=80=99 defined but not used [-Wunused-const-variable=3D]
>   CC      drivers/soc/mediatek/mtk-scpsys.o
> drivers/soc/mediatek/mtk-scpsys.c:1084:34: warning: =E2=80=98of_scpsys_ma=
tch_tbl=E2=80=99 defined but not used [-Wunused-const-variable=3D]
> (...)

This is warning only, pretty harmless, so I don't think this qualifies
for stable kernel trees.

Thanks,
--=20
Jean Delvare
SUSE L3 Support
