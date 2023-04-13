Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10BF36E08EC
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 10:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjDMIaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 04:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjDMIap (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 04:30:45 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E0CB5;
        Thu, 13 Apr 2023 01:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net; s=s31663417;
        t=1681374640; i=secu100@gmx.net;
        bh=JuB/8Df5JPEkDBJvzkYX19UwLMGlrI3SNhkkgdoSeJo=;
        h=X-UI-Sender-Class:Date:To:Cc:From:Subject;
        b=Pz2poCRg44qD28wNOz52xNsjatSLqfsP4utblB93n3gS1W581WwFIObtTozyQRja6
         qglUPO9aeVaRngm18eEf1LqTtCwlGY5UhkegV8zjrXhMTrlOeRCBiGCwD3h6o4NRtV
         OdDtLUExXNFEnZnydz2SsYuphN5wVh5Fd4FJtXrsBnekSN3MMdqEFAPUz3/G3wCG8N
         7FWx5HQJO0hsCN6fQRg8B5UuSzo6wkNhIToCev0MVkm5W+wnCc9aof0oFa0r574b4J
         I4qm8tAyAVi4zC4K8ywNxVI2tkZ+JW1YKHWb7DJdOW9eYUcx3oG94uKJH2Tz7jY0YM
         iQRP9HzPi/jaw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.178.22] ([93.212.130.164]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M2O2W-1pnPmL3t5K-003z9R; Thu, 13
 Apr 2023 10:30:39 +0200
Message-ID: <25ce0797-1d40-6e2b-0895-c4ca85aad2e6@gmx.net>
Date:   Thu, 13 Apr 2023 10:28:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
To:     stable@vger.kernel.org
Cc:     kernel@vger.kernel.org, ",patches"@lists.linux.dev
From:   "secu100@gmx.net" <secu100@gmx.net>
Subject: [PATCH 6.1.23] ALSA: hda/realtek: Add quirk for HP ENVY Laptop
 17-cr0xxx
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:weZ28mZKBKQwTACGQV6Era4MKTLhKvXLYCGJ84pkUy849IXLsBT
 OXyd22fsOTs3iTGXKr+Jq/LDi/pKfcM3um8oMpyuiktsMry47G9X14rnVVnDUT0pt9+Z5wQ
 eHL9er40OtS0uc23utUPVu9QmHAIOo/Fhw1oK+taoYNRuVBq5U5z0/3xjpEUC5aXIS9Ssye
 yDxQ42/aZIXilI2gL4WnA==
UI-OutboundReport: notjunk:1;M01:P0:0aXAkIkYhhk=;z5ydRsju0G8G1vmoBRGOI/354l4
 Lwh9steMrLeaJxhGZsxOqr11DYkkWZLH+A9LLTmiopaXv4CbebWaPh8hL7wjN44I2djEadK9t
 2MzZYGSBSXmdiJTL59qQHUvalhvdxXrftN+KvzTgh/vmvbu98SdH9HxG4sGkhJmk4dbLXBa5k
 tB0cuviTFXzbMwtpEdeyguQBbzJk5596mbNw9bGqycxsZzCSTjS3xCto6gJLZ8SXi+kz110qg
 AOH2NQE6Jlzob3FZulTcYvLc2MzD0eOc0L3fWFyU+crPcb/BdkMTyIZBxCIV+wS06FjkWIyJr
 zimGgmWKcnAK8sDdWIc5J7QpWZdZ1g8/z8qok2aPsQgsvWuBQ+ZnVrzwT4qsJyo5KJIdFej38
 Pm3TgG1NpBSIhBruC2xuQ5YmaK6wC4yql0xEEi328Eio7PJpw83/QPGkN8T7jwmYwUk2XW2d4
 CRZUK6zsAD0Lo5JMjpSgwtrt30mRu1bBDsWPrxDHb1YNUIUdGgF7mn7yVwvvXltb5A1XwLdQ0
 SeBFUcbN/z8ZY/4iZ1gXHZ616/SPL3Xwk1wvNqASFnYjh1BFYTUNJuNjVsh3+YFOEtiuR8lN7
 rqWDNwowN2Q3hGxZ7M3UWrYthYSv4/wFzviaYtuZWx03t2ID83Am47eAyJNT3qFZC4sPs2K5c
 MD/Uh9eaGGSO+ggzzf1TZnVDxoj4Q74tdbheW3FilGhv0n8h/DdfBcTKucKQjpMZ1zrVmGiq6
 3wsen4e/ton2cNnyBYdjW2c8/9hjqIiPyNCrAqRE8ngRshIU+nqZER7HNOCC7h2EmdizXgEBM
 5c+lyah7piDE3aLpYVqtMpZ2g55tKLPkfVfTVRsdPTT38P+NkdvU8bmOaKwlBrkW5eF6JVzyc
 3OCVBQOoeSqtJ/Rxt39EaRQDu/txm0lzQ77HML8bnz6/NQa3xznPa3UV5xfAD8m66plcQhJzO
 fp3I/6gTikIFzZ4k1Yie+SWQ3kA=
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

