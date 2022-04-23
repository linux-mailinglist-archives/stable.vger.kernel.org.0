Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0AC550C967
	for <lists+stable@lfdr.de>; Sat, 23 Apr 2022 12:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235047AbiDWKzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Apr 2022 06:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235093AbiDWKzh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Apr 2022 06:55:37 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6851FFDDD;
        Sat, 23 Apr 2022 03:52:39 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 1C7005C00E6;
        Sat, 23 Apr 2022 06:52:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 23 Apr 2022 06:52:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pks.im; h=cc:cc
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1650711157; x=1650797557; bh=UE1GerCR9T
        LmzaV9tns9QX/P+hEnHBRCJ/KKmCkbz1k=; b=DpMg52adGu8bG69Y4pZkmTU5V+
        d+rJhUM1R6+bhTuHFdJfDf0Z8/lXMoN2nCCfGFokAKW5boTIidKSI4CWwJc6oLVN
        se0DUWQ1BZqqyTHdDiQsRUdCKhbJXVVcnbYOspn8S8ti15/fMehGRjvv94zozylc
        dGWT3EOm93zrnI5R8nT8C+gq9GbaAEWGR1cafWsoOYHt5jl3uCQAuztjKTL/0wR6
        zAMaLhk/T6iBxQZpQSDFzft/FhN9/EsbO040ASt5aB7x+Bb2tEbvhYl2cLRVEw9f
        sCOZu75kkWb380GC3L8EZ7a74u11ltWsKunZEWvUmwT3kq69lTdLyF2x7zRg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1650711157; x=
        1650797557; bh=UE1GerCR9TLmzaV9tns9QX/P+hEnHBRCJ/KKmCkbz1k=; b=O
        3nG5iyYeCtVi7aMp8k3niKM4ykY3ooHpiGgTRXRWO2U6rP6+THDz+q1nxd0vF4jW
        ngVonQdbuzt4/e+qW/IQn7wpqgG7bd0mGOZtWNl+ZFpkP0z6sey+D5tNeCBVqOmM
        klJOASfK/N/P2ghEJ1ASakpjeb+9pU2kQq2RHHyx2dhGgwRbh8CJ+2yG7B2hpseo
        ZG2WUMLQJdg1d2G41PyaDgX2b7gEpeGWcXxeWRTMxbqK+K5SepEFnCdgEKmb9uod
        QTOi8tkBZ53C64ABYRLvg8NBerPwO0npg/day8RW8IyAvieJewjYbzcR6gvZl377
        hFZTgsqwgVhIdZyaxMURA==
X-ME-Sender: <xms:dNpjYj9hVS57y590vJkL7LAw0DxAUWXGoI0DWB2xJyheNFOqYuXWpg>
    <xme:dNpjYvsdw_9emZQCQ4P0XpEu3cxb5RyNCBxThHet3FS58ji1uUCmtKPQ15NcME7gC
    n4I03WS-h9UkiAxDw>
X-ME-Received: <xmr:dNpjYhCex3e6_I8l-XOnTZ5ilHXg-nM6L_7KhJFanSLeY5covBA_dDWnIhfLGe5devN1GaOU2rgKfyta92BeH-hzWPazo__XKuHLk1z74gAIb_ycXrsDTA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrtdeigdeffecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehgtderredttddvnecuhfhrohhmpefrrghtrhhi
    tghkucfuthgvihhnhhgrrhguthcuoehpshesphhkshdrihhmqeenucggtffrrghtthgvrh
    hnpeehgeefhfeuueeghffglefffeduudeffffgfeduleehtddttdelieduudeukedvgeen
    ucffohhmrghinhepghhithhhuhgsrdgtohhmpdgrrhgthhhlihhnuhigrdhorhhgpdhinh
    hfrhgruggvrggurdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepphhssehpkhhsrdhimh
X-ME-Proxy: <xmx:dNpjYvcYpDMCGRcKB34PB7rNyhCpoT9oSEJQGrLSrddoKBbqCE-PtA>
    <xmx:dNpjYoNPRN3P7Jk2gTiOkX5w30aRgYtrsq6WrWi2OrxAURZoAGoKpA>
    <xmx:dNpjYhkpMP18LvTtMiGSS9Z5rCz0Fbox4ENHfN8VRA-zdZXlWJdKoQ>
    <xmx:ddpjYlqwJAkB7w-JIQQABeWBXDNxzYEI_LXz9Tg1MPCJ-A8b4kYAEQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 23 Apr 2022 06:52:35 -0400 (EDT)
Received: from localhost (xps [10.192.0.12])
        by vm-mail.pks.im (OpenSMTPD) with ESMTPSA id c92f9d6c (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 23 Apr 2022 10:52:32 +0000 (UTC)
Date:   Sat, 23 Apr 2022 12:52:37 +0200
From:   Patrick Steinhardt <ps@pks.im>
To:     Brian Norris <briannorris@chromium.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wen Gong <wgong@codeaurora.org>
Subject: Re: [PATCH] Revert "ath: add support for special 0x0 regulatory
 domain"
Message-ID: <YmPadTu8CfEARfWs@xps>
References: <20200527165718.129307-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fPTOmHiq9JC98ggj"
Content-Disposition: inline
In-Reply-To: <20200527165718.129307-1-briannorris@chromium.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--fPTOmHiq9JC98ggj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 27, 2020 at 09:57:18AM -0700, Brian Norris wrote:
> This reverts commit 2dc016599cfa9672a147528ca26d70c3654a5423.
>=20
> Users are reporting regressions in regulatory domain detection and
> channel availability.
>=20
> The problem this was trying to resolve was fixed in firmware anyway:
>=20
>     QCA6174 hw3.0: sdio-4.4.1: add firmware.bin_WLAN.RMH.4.4.1-00042
>     https://github.com/kvalo/ath10k-firmware/commit/4d382787f0efa77dba403=
94e0bc604f8eff82552
>=20
> Link: https://bbs.archlinux.org/viewtopic.php?id=3D254535
> Link: http://lists.infradead.org/pipermail/ath10k/2020-April/014871.html
> Link: http://lists.infradead.org/pipermail/ath10k/2020-May/015152.html
> Fixes: 2dc016599cfa ("ath: add support for special 0x0 regulatory domain")
> Cc: <stable@vger.kernel.org>
> Cc: Wen Gong <wgong@codeaurora.org>
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
>  drivers/net/wireless/ath/regd.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/r=
egd.c
> index bee9110b91f3..20f4f8ea9f89 100644
> --- a/drivers/net/wireless/ath/regd.c
> +++ b/drivers/net/wireless/ath/regd.c
> @@ -666,14 +666,14 @@ ath_regd_init_wiphy(struct ath_regulatory *reg,
> =20
>  /*
>   * Some users have reported their EEPROM programmed with
> - * 0x8000 or 0x0 set, this is not a supported regulatory
> - * domain but since we have more than one user with it we
> - * need a solution for them. We default to 0x64, which is
> - * the default Atheros world regulatory domain.
> + * 0x8000 set, this is not a supported regulatory domain
> + * but since we have more than one user with it we need
> + * a solution for them. We default to 0x64, which is the
> + * default Atheros world regulatory domain.
>   */
>  static void ath_regd_sanitize(struct ath_regulatory *reg)
>  {
> -	if (reg->current_rd !=3D COUNTRY_ERD_FLAG && reg->current_rd !=3D 0)
> +	if (reg->current_rd !=3D COUNTRY_ERD_FLAG)
>  		return;
>  	printk(KERN_DEBUG "ath: EEPROM regdomain sanitized\n");
>  	reg->current_rd =3D 0x64;
> --=20
> 2.27.0.rc0.183.gde8f92d652-goog
>=20

This revert is in fact causing problems on my machine. I have a QCA9984,
which exports two network interfaces. While I was able to still use one
of both NICs for 2.4GHz, I couldn't really use the other card to set up
a 5GHz AP anymore because all frequencies were restricted. This has
started with v5.17.1, to which this revert was backported.

Reverting this patch again fixes the issue on my system. So it seems
like there still are cards out there in the wild which have a value of
0x0 as their regulatory domain.

Quoting from your other mail:

> My understanding was that no QCA modules *should* be shipped with a
> value of 0 in this field. The instance I'm aware of was more or less a
> manufacturing error I think, and we got Qualcomm to patch it over in
> software.

This sounds like the issue should've already been fixed in firmware,
right? To the best of my knowledge I'm using the latest that's currently
available, which seems to contradict this. I've added the relevant dmesg
snippets though in case I'm mistaken:

    ath10k_pci 0000:03:00.0: enabling device (0000 -> 0002)
    ath10k_pci 0000:03:00.0: pci irq msi oper_irq_mode 2 irq_mode 0 reset_m=
ode 0
    ath10k_pci 0000:04:00.0: enabling device (0000 -> 0002)
    ath10k_pci 0000:04:00.0: pci irq msi oper_irq_mode 2 irq_mode 0 reset_m=
ode 0
    ath10k_pci 0000:03:00.0: qca9984/qca9994 hw1.0 target 0x01000000 chip_i=
d 0x00000000 sub 168c:cafe
    ath10k_pci 0000:03:00.0: kconfig debug 0 debugfs 0 tracing 0 dfs 1 test=
mode 0
    ath10k_pci 0000:03:00.0: firmware ver 10.4-3.9.0.2-00131 api 5 features=
 no-p2p,mfp,peer-flow-ctrl,btcoex-param,allows-mesh-bcast,no-ps,peer-fixed-=
rate,iram-recovery crc32 23bd9e43
    ath10k_pci 0000:04:00.0: qca9984/qca9994 hw1.0 target 0x01000000 chip_i=
d 0x00000000 sub 168c:cafe
    ath10k_pci 0000:04:00.0: kconfig debug 0 debugfs 0 tracing 0 dfs 1 test=
mode 0
    ath10k_pci 0000:04:00.0: firmware ver 10.4-3.9.0.2-00131 api 5 features=
 no-p2p,mfp,peer-flow-ctrl,btcoex-param,allows-mesh-bcast,no-ps,peer-fixed-=
rate,iram-recovery crc32 23bd9e43
    ath10k_pci 0000:03:00.0: board_file api 2 bmi_id 0:1 crc32 85498734
    ath10k_pci 0000:04:00.0: board_file api 2 bmi_id 0:2 crc32 85498734
    ath10k_pci 0000:03:00.0: htt-ver 2.2 wmi-op 6 htt-op 4 cal otp max-sta =
512 raw 0 hwcrypto 1
    ath: EEPROM regdomain sanitized
    ath: EEPROM regdomain: 0x64
    ath: EEPROM indicates we should expect a direct regpair map
    ath: Country alpha2 being used: 00
    ath: Regpair used: 0x64
    ath10k_pci 0000:04:00.0: htt-ver 2.2 wmi-op 6 htt-op 4 cal otp max-sta =
512 raw 0 hwcrypto 1
    ath: EEPROM regdomain sanitized
    ath: EEPROM regdomain: 0x64
    ath: EEPROM indicates we should expect a direct regpair map
    ath: Country alpha2 being used: 00
    ath: Regpair used: 0x64

Patrick

--fPTOmHiq9JC98ggj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF9hrgiFbCdvenl/rVbJhu7ckPpQFAmJj2nQACgkQVbJhu7ck
PpR9KhAAiF4B5kQfSXTMPny/kJcAHZn0zrVMyGxLFsrKNwucmhArlaT3n7QCxZ8C
6vw0oGMXzkc/nA3fYE/O1P8UUzCQYlVPYqVK6iMSfrcfdGR87kPU8bMltSR4DVoo
Sg4vtGixrTVT1/nG4pzoxnGw8nceuUKgbu3gPa1HWdE+RKkIILNrvq3fNo9utmMk
nKRXay4P1qgotr2Hydc/OA/PRl/LmydvO39uXLX8H2lZN3wxYEQlhukbkErdyILB
OCwyy7m+9cxLt0HPZjNo4lhQGR0QnwcOo6GoL+gaVeljM6XyCusnAXud6WZd0EcL
0tOBuADbe30plhm4Vp+fbHBA3lA1JETBCvpPaaJNVo06NgqLnBdfG1rP2PLaEMfq
mFFH7fbW5qNUg57JPrqwz1F8FAfLK7DOpOXcymkC9wqgTVclQJvcTKJWlRpRXJ1x
lwEsN0lB4Y+6zOA0zwsIiUGC4IY6/BGEaEYuDhVYazhYPSDMzM+S/2Wn6zQW02Di
yea/qAcKITL4eE1OiquRJaJtbGEX9OcG3Vg5kgW+WTD1tx/JgSbQCYl/Ayqj+rEN
/sHa5zm4S4BRXGbA9+1Q9quYQYS0RE6nBaAUYBZEhT/8swWCGGnNMSXG3ZOUfYi7
/hMRvB6IWOTtviqLJAmADqsaISjk26JTeODnYMdQQcIOeUFyqXY=
=MzMM
-----END PGP SIGNATURE-----

--fPTOmHiq9JC98ggj--
