Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86BA26E08FB
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 10:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjDMIeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 04:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjDMIeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 04:34:13 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7942108;
        Thu, 13 Apr 2023 01:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net; s=s31663417;
        t=1681374846; i=secu100@gmx.net;
        bh=JuB/8Df5JPEkDBJvzkYX19UwLMGlrI3SNhkkgdoSeJo=;
        h=X-UI-Sender-Class:Date:Subject:References:To:Cc:From:In-Reply-To;
        b=iBPaUVJE2Tw9ftzeoxrvp8G+jwPE+L4NQOhDQQXW9vAXQTI5qG16np9HmqFvieWaK
         ITIU1thk0m11eyb/ZwWp3sRfDcnT5p/Z9XX9M+SADpYpV80cQeqmm6ppqdEwzzxp7F
         Rnin1Bk71Bw+snM9CYYuh4+tRcgScnsfOx89DVSNLwStCtU1ZU8grZndLBRfmHymHc
         tJXSYY3VvKcdZVI950UdNsZwt5xzB5wOG0bj2fqs4GnGfqIUkoAeyfj4r3C76FkK/Y
         uF1+BVqx5ha9dEjuJnvMDKSWC7eHDTCLzMH+IMBXFJXOsGLgJhsNNt9X8ouG4FgL+X
         Acf449GFKDTUg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.178.22] ([93.212.130.164]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MTABZ-1pvyFt1AQ3-00Uce3; Thu, 13
 Apr 2023 10:34:06 +0200
Message-ID: <30f48ec1-df68-68e2-f81f-538e5526599e@gmx.net>
Date:   Thu, 13 Apr 2023 10:32:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: [PATCH 6.1.23] ALSA: hda/realtek: Add quirk for HP ENVY Laptop
 17-cr0xxx
References: <25ce0797-1d40-6e2b-0895-c4ca85aad2e6@gmx.net>
To:     stable@vger.kernel.org
Cc:     kernel@vger.kernel.org, patches@lists.linux.dev
From:   "secu100@gmx.net" <secu100@gmx.net>
In-Reply-To: <25ce0797-1d40-6e2b-0895-c4ca85aad2e6@gmx.net>
X-Forwarded-Message-Id: <25ce0797-1d40-6e2b-0895-c4ca85aad2e6@gmx.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:AeR3DtBk8wIp4Pd/PFDBNXTo5fGJiSxRvhN60wUsgQfF8o2QPo4
 RV65YwiJWjUYIHNYERbg6vpUx3d8xU7CMVAIaBTh726xtG0zeDIq2e7tryS0stBYwXK7zDQ
 SPsGZ+zjWAKn2ZpfefexDiqdSq1Kq5y6T+CEFyYMUik+/iHXmb8VfjZMPrfYo3kfY10dNNq
 Ree1HGWITyF8wu0NY2kTg==
UI-OutboundReport: notjunk:1;M01:P0:LrXcOaS+3w8=;+SjxOydbkme88SKtQG+LSv0mYKu
 epgNC3JHX0vp5bOR7LSjsafxKHVRRFtNIo2RpShLQGnYNXPL5sDLrRyq6huVgGMi5bJmX0ouS
 kNcx2moa0WhnY2zO3YcMQixOs0iJeZwsjeOQKlF//VvL/EvkAdMMEtXllfbH+o9hq40SDQTYJ
 0yR5GT2TSmvmN7HyG1KwnG98y/qRipz0EYyk62WPgpRnoABRfURlo/r4wJ6BS4nxtNAKed4KF
 yNH2D6+WK4XguJzMIvt6rLbbGETR/9l2gEEg2EdP3AOxLp6cIMm+bukmh8PNgub8L0sZNXimM
 UJZ6DBMFAQ09oFQenZVtAMzWxEuGRc/yuaRo8BjMRc+xAUxjxLC100LAux8Xk9d9GVoVQ+LtX
 fu5jJbfRNLO114U5Ka/j8MILJ0uWrC+hD8iHdEy2VFIcdybsOhbrf218Lxs+bazpUJLuSPkbc
 WDmIuOVMCcGJblBlZcwcnL/ATUcxZPuFSXlYbDk6NS6cNpcR9jpuHPXC2rf2aNFhUcYmD0uxZ
 j5KkNobRvDXXBm/RHoHpPEVeNje+Ed7o74T9TO9L0VqKctFtfKAbo3Fech8tapWSzXXehGMNp
 udd0ZhyWTqVhwyy9oXCN+4JlQuf1yVQSGHLsNC8uplupH69WrzRu5wTEXPx4wUltf2dsMuHj0
 9kjz90JY1V6WonlaU24F8rTxlO13fnUbh4cETSffVwSBscF/8yXO9FhUILztZwIVhgiRz/fuf
 6j8C4EhuFmca1MvEJ41IAe7RR50uB3qQ+vsdBAo9NPLbs5hS2ebP+fnv3HZobcaLMoEkObvY+
 F+i18BDAUBekRCqylYXbg7Z09wtP81h5kBognq/o+F9mSRwMsE9o1KFVbpmRjwfE4ZPXbgwUC
 IW2eRlyuLqjDud1hVZbt72ShrCTcwrWUOAA6PFgtAR/IBSLn6ulzqqDhuIdYjtOTTUsVFrmao
 wL1dMQ/qgBWHxXHB1CUW+FPTH08=
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,GB_FREEMAIL_DISPTO,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch of the file patch_realtek.c fixes the speaker output on the HP
ENVY Laptop 17-cr0xxx. The LEDs for muting the microphone and speakers
still do not work. Likewise, the hotkey for microphone muting is without
function.

This laptop model uses actually the Realtek ALC245 codec alongside with
Cirrus Logic amplifiers. In the bios there seems to be no _DSD property
specified in the ACPI tables of the CSC3551 section. Therefore, the file
cs35l41_hda.c must also be patched.

Even if a patch of the file cs35l41_hda.c is excluded, it would make
sense to make the adjustment in the file patch_realtek.c. then the sound
output would work in case of a bios update on the part of the manufacturer=
.


=2D-- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9426,6 +9426,7 @@ static const struct snd_pci_quirk alc269
 =C2=A0=C2=A0=C2=A0=C2=A0 SND_PCI_QUIRK(0x103c, 0x89c6, "Zbook Fury 17 G9"=
,
ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 =C2=A0=C2=A0=C2=A0=C2=A0 SND_PCI_QUIRK(0x103c, 0x89ca, "HP",
ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 =C2=A0=C2=A0=C2=A0=C2=A0 SND_PCI_QUIRK(0x103c, 0x89d3, "HP EliteBook 645 =
G9 (MB 89D2)",
ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+=C2=A0=C2=A0=C2=A0 SND_PCI_QUIRK(0x103c, 0x8a2e, "HP ENVY Laptop 17-cr0xx=
x",
ALC287_FIXUP_CS35L41_I2C_2),
 =C2=A0=C2=A0=C2=A0=C2=A0 SND_PCI_QUIRK(0x103c, 0x8a78, "HP Dev One",
ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 =C2=A0=C2=A0=C2=A0=C2=A0 SND_PCI_QUIRK(0x103c, 0x8aa0, "HP ProBook 440 G9=
 (MB 8A9E)",
ALC236_FIXUP_HP_GPIO_LED),
 =C2=A0=C2=A0=C2=A0=C2=A0 SND_PCI_QUIRK(0x103c, 0x8aa3, "HP ProBook 450 G9=
 (MB 8AA1)",
ALC236_FIXUP_HP_GPIO_LED),



=2D-- a/sound/pci/hda/cs35l41_hda.c
+++ b/sound/pci/hda/cs35l41_hda.c
@@ -1244,6 +1244,10 @@ static int cs35l41_no_acpi_dsd(struct cs
 =C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 hw_cfg->bst_type =3D CS35L41_=
EXT_BOOST;
 =C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 hw_cfg->gpio1.func =3D CS35l4=
1_VSPK_SWITCH;
 =C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 hw_cfg->gpio1.valid =3D true;
+=C2=A0=C2=A0=C2=A0 } else if (strncmp(hid, "CSC3551", 7) =3D=3D 0) {
+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 hw_cfg->bst_type =3D CS35L41_EXT_BO=
OST;
+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 hw_cfg->gpio1.func =3D CS35l41_VSPK=
_SWITCH;
+=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 hw_cfg->gpio1.valid =3D true;
 =C2=A0=C2=A0=C2=A0=C2=A0 } else {
 =C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 /*
 =C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0* Note: CLSA010(0/1) ar=
e special cases which use a slightly
different design.

