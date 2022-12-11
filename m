Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9B16496DB
	for <lists+stable@lfdr.de>; Sun, 11 Dec 2022 23:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiLKWy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Dec 2022 17:54:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLKWy1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Dec 2022 17:54:27 -0500
Received: from smtpauth.rollernet.us (smtpauth.rollernet.us [IPv6:2607:fe70:0:3::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219A5767B
        for <stable@vger.kernel.org>; Sun, 11 Dec 2022 14:54:27 -0800 (PST)
Received: from smtpauth.rollernet.us (localhost [127.0.0.1])
        by smtpauth.rollernet.us (Postfix) with ESMTP id 3A668280004A
        for <stable@vger.kernel.org>; Sun, 11 Dec 2022 14:54:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aronetics.com;
         h=from:to:subject:date:message-id:mime-version:content-type; s=
        roll2210; t=1670799266; bh=3Bs2kGU3W7vczeW8Vgg61eRLzTvflegRkPjQH
        42iHeg=; b=dTQ/uXrX9W0cLJtUkxvelvoBoHrPD5ncxjfKqXGT8YgkBHUZtGiqO
        CvXmaTdjblWKByM4mim8JNlycozGarnFf3ADiSZnrLcKB9TseMjlS8wwQiYBKgzc
        A5P5R3kGrAOmPAzfwY3ji2Jd5WKa2ImbxHOSy54NhuFvMGf18BS1nn3FNXAQ8056
        logD/x4Dj6hzRtMm76F5QZ4ZBqDS3TwrqoESsUNIs23uGDkrQC1XBlQ8bI9mlPJl
        Bcfg36zb5EWLJmkwABphMcTh3ypHF3dEvEa+O3HpxA8H86C6zqEf3XjzkXFGK9sO
        vUBi3Yd+KPTFRLoxdo3atUTG+CtH03TVg==
From:   "John Aron" <john@aronetics.com>
To:     <stable@vger.kernel.org>
Subject: Slackware 15 on Blade 14
Date:   Sun, 11 Dec 2022 17:54:08 -0500
Message-ID: <00a801d90db3$7b121530$71363f90$@aronetics.com>
X-Mailer: Microsoft Outlook 16.0
MIME-Version: 1.0
Content-Language: en-us
Thread-Index: AdkNs3S3ohB2cUMPTvSkGnknGXzC7g==
Content-Type: multipart/signed;
        micalg=SHA1;
        boundary="----=_NextPart_000_00A2_01D90D89.8F51BE80";
        protocol="application/x-pkcs7-signature"
X-Rollernet-Modified: Received headers cleared at submission by user request
X-Rollernet-Abuse: Contact abuse@rollernet.us to report. Abuse policy: http://www.rollernet.us/policy
X-Rollernet-Submit: Submit ID 71f7.63965fa2.1f82b.0
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multipart message in MIME format.

------=_NextPart_000_00A2_01D90D89.8F51BE80
Content-Type: multipart/mixed;
	boundary="----=_NextPart_001_00A3_01D90D89.8F51BE80"


------=_NextPart_001_00A3_01D90D89.8F51BE80
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Happy Sunday, I have a kernel bug to report.

It occurs and is repeatable on this Razer Blade 14. This laptop is Slackware
15 and using the 5.15.19 kernel. I have attached my core file which is a bad
name as I cut possibly irrelevant segments from the 'dmesg.'

The RIP is at gm200_devinit_post 

Best regards,
John

V/r,
John

aronetics.com
We Speak ITR



------=_NextPart_001_00A3_01D90D89.8F51BE80
Content-Type: application/octet-stream;
	name="core.dat"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="core.dat"

[    0.000000] Linux version 5.15.19 (root@z-mp.slackware.lan) (gcc =
(GCC) 11.2.0, GNU ld version 2.37-slack15) #1 SMP PREEMPT Wed Feb 2 =
01:50:51 CST 2022=0A=
[    0.000000] Command line: BOOT_IMAGE=3Ddev000:\EFI\SLACKWARE\vmlinuz  =
root=3D/dev/nvme0n1p3 vga=3Dnormal ro ro=0A=
[    8.192407] ------------[ cut here ]------------=0A=
[    8.192423] nouveau 0000:01:00.0: timeout=0A=
[    8.192446] WARNING: CPU: 6 PID: 705 at =
drivers/gpu/drm/nouveau/nvkm/subdev/devinit/gm200.c:161 =
gm200_devinit_post+0x243/0x270 [nouveau]=0A=
[    8.192544] Modules linked in: snd_hda_codec_realtek =
snd_hda_codec_generic ledtrig_audio hid_rmi rmi_core intel_rapl_msr =
intel_rapl_common intel_tcc_cooling x86_pkg_temp_thermal =
intel_powerclamp coretemp i2c_designware_platform kvm_intel mei_hdcp =
8250_dw i2c_designware_core i915 kvm ath10k_pci irqbypass uvcvideo =
crct10dif_pclmul crc32_pclmul videobuf2_vmalloc snd_hda_codec_hdmi =
nouveau(+) ghash_clmulni_intel videobuf2_memops ath10k_core cec =
snd_hda_intel snd_intel_dspcfg btusb rapl ath snd_intel_sdw_acpi =
drm_ttm_helper videobuf2_v4l2 ttm btrtl rc_core intel_cstate =
snd_hda_codec dcdbas videobuf2_common snd_hda_core drm_kms_helper btbcm =
dell_wmi_descriptor wmi_bmof mac80211 snd_hwdep btintel =
intel_wmi_thunderbolt mxm_wmi i2c_i801 videodev snd_pcm drm i2c_smbus =
bluetooth snd_timer intel_gtt joydev mc ecdh_generic ecc cfg80211 snd =
agpgart intel_lpss_pci soundcore mei_me i2c_algo_bit intel_lpss =
fb_sys_fops syscopyarea idma64 sysfillrect mei sysimgblt =
intel_pch_thermal mfd_core thermal fan=0A=
[    8.192577]  i2c_hid_acpi ac pinctrl_sunrisepoint evdev acpi_pad =
button loop xfs hid_multitouch hid_microsoft hid_lenovo =
hid_logitech_hidpp hid_logitech_dj hid_logitech hid_cherry hid_asus =
asus_wmi platform_profile battery sparse_keymap rfkill wmi video =
hid_generic i2c_hid i2c_core usbhid hid uhci_hcd ohci_pci ehci_pci =
ohci_hcd ehci_hcd xhci_pci xhci_pci_renesas xhci_hcd usb_storage=0A=
[    8.194692] CPU: 6 PID: 705 Comm: udevd Not tainted 5.15.19 #1=0A=
[    8.195720] Hardware name: Razer Blade/Blade, BIOS 5.00 05/03/2018=0A=
[    8.196730] RIP: 0010:gm200_devinit_post+0x243/0x270 [nouveau]=0A=
[    8.197810] Code: 8b 40 10 48 8b 78 10 4c 8b 67 50 4d 85 e4 75 03 4c =
8b 27 e8 1f 13 9f de 4c 89 e2 48 c7 c7 68 b0 e0 c0 48 89 c6 e8 dc 93 d8 =
de <0f> 0b 41 bc 92 ff ff ff e9 58 fe ff ff 8b 55 30 85 d2 0f 85 f6 06=0A=
[    8.198871] RSP: 0018:ffffa313c0e8b8e0 EFLAGS: 00010282=0A=
[    8.199929] RAX: 0000000000000000 RBX: ffff90b6831b8400 RCX: =
0000000000000000=0A=
[    8.201000] RDX: 0000000000000001 RSI: 00000000ffffdfff RDI: =
00000000ffffffff=0A=
[    8.202060] RBP: ffff90b680f93c80 R08: 0000000000000000 R09: =
ffffa313c0e8b718=0A=
[    8.203116] R10: ffffa313c0e8b710 R11: ffffffffa073bee8 R12: =
ffff90b6817aaad0=0A=
[    8.204167] R13: 0000000000000001 R14: ffff90b6831b8400 R15: =
ffff90b680f93700=0A=
[    8.205221] FS:  00007fccb9540140(0000) GS:ffff90b9fed80000(0000) =
knlGS:0000000000000000=0A=
[    8.206273] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033=0A=
[    8.207317] CR2: 00007fccb9c01a30 CR3: 0000000102a4a006 CR4: =
00000000003706e0=0A=
[    8.208376] Call Trace:=0A=
[    8.209433]  <TASK>=0A=
[    8.210503]  nvkm_devinit_post+0x28/0x50 [nouveau]=0A=
[    8.211588]  nvkm_device_init+0xa1/0x1b0 [nouveau]=0A=
[    8.212677]  nvkm_udevice_init+0x41/0x60 [nouveau]=0A=
[    8.213763]  nvkm_object_init+0x3e/0x110 [nouveau]=0A=
[    8.214815]  nvkm_ioctl_new+0x16c/0x1e0 [nouveau]=0A=
[    8.215870]  ? nvkm_client_notify+0x30/0x30 [nouveau]=0A=
[    8.216946]  ? nvkm_udevice_rd08+0x20/0x20 [nouveau]=0A=
[    8.217997]  nvkm_ioctl+0xd5/0x180 [nouveau]=0A=
[    8.219041]  nvif_object_ctor+0x14b/0x230 [nouveau]=0A=
[    8.220077]  nvif_device_ctor+0x1f/0x60 [nouveau]=0A=
[    8.221113]  nouveau_cli_init+0x15e/0x450 [nouveau]=0A=
[    8.222144]  ? kmem_cache_alloc_trace+0x285/0x400=0A=
[    8.223109]  nouveau_drm_device_init+0x74/0x790 [nouveau]=0A=
[    8.224150]  ? pci_bus_read_config_word+0x49/0x70=0A=
[    8.225148]  ? pci_update_current_state+0x9d/0xc0=0A=
[    8.226138]  nouveau_drm_probe+0x11b/0x1e0 [nouveau]=0A=
[    8.227159]  ? _raw_spin_unlock_irqrestore+0x1b/0x30=0A=
[    8.228149]  local_pci_probe+0x45/0x80=0A=
[    8.229111]  ? pci_match_device+0xd7/0x130=0A=
[    8.230025]  pci_device_probe+0xfa/0x1b0=0A=
[    8.230955]  really_probe.part.0+0xb8/0x2a0=0A=
[    8.231878]  __driver_probe_device+0x90/0x120=0A=
[    8.232791]  driver_probe_device+0x1e/0xe0=0A=
[    8.233734]  __driver_attach+0xab/0x170=0A=
[    8.234644]  ? __device_attach_driver+0xe0/0xe0=0A=
[    8.235589]  bus_for_each_dev+0x78/0xc0=0A=
[    8.236570]  bus_add_driver+0x10b/0x1c0=0A=
[    8.237491]  driver_register+0x8f/0xe0=0A=
[    8.238412]  ? 0xffffffffc0ee7000=0A=
[    8.239307]  do_one_initcall+0x44/0x200=0A=
[    8.240209]  ? kmem_cache_alloc_trace+0x45/0x400=0A=
[    8.241110]  do_init_module+0x5c/0x270=0A=
[    8.241972]  __do_sys_finit_module+0xa0/0xe0=0A=
[    8.242885]  do_syscall_64+0x3b/0xc0=0A=
[    8.243795]  entry_SYSCALL_64_after_hwframe+0x44/0xae=0A=
[    8.244699] RIP: 0033:0x7fccb9a53c09=0A=
[    8.245610] Code: 48 8d 3d 6a 1f 0d 00 0f 05 eb a5 66 0f 1f 44 00 00 =
48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f =
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 2f e2 0c 00 f7 d8 64 89 01 48=0A=
[    8.246560] RSP: 002b:00007ffcd5e69398 EFLAGS: 00000246 ORIG_RAX: =
0000000000000139=0A=
[    8.247568] RAX: ffffffffffffffda RBX: 0000000001b0c150 RCX: =
00007fccb9a53c09=0A=
[    8.248513] RDX: 0000000000000000 RSI: 00007fccb9b40a9d RDI: =
0000000000000013=0A=
[    8.249446] RBP: 0000000000020000 R08: 0000000000000000 R09: =
0000000000020000=0A=
[    8.250364] R10: 0000000000000013 R11: 0000000000000246 R12: =
00007fccb9b40a9d=0A=
[    8.251269] R13: 0000000000000000 R14: 0000000001b1be10 R15: =
0000000001b0c150=0A=
[    8.252195]  </TASK>=0A=
[    8.253097] ---[ end trace c465ad28b93c6277 ]---=0A=

------=_NextPart_001_00A3_01D90D89.8F51BE80--

------=_NextPart_000_00A2_01D90D89.8F51BE80
Content-Type: application/pkcs7-signature;
	name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="smime.p7s"

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIXlzCCA1cw
ggI/oAMCAQICAQEwDQYJKoZIhvcNAQELBQAwTTELMAkGA1UEBhMCVVMxGDAWBgNVBAoTD1UuUy4g
R292ZXJubWVudDEMMAoGA1UECxMDRUNBMRYwFAYDVQQDEw1FQ0EgUm9vdCBDQSA0MB4XDTEyMDMy
MDE2MTMwNFoXDTI5MTIzMDE2MTMwNFowTTELMAkGA1UEBhMCVVMxGDAWBgNVBAoTD1UuUy4gR292
ZXJubWVudDEMMAoGA1UECxMDRUNBMRYwFAYDVQQDEw1FQ0EgUm9vdCBDQSA0MIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuHBpV72AWkHAGeaV59SCE9wsOEuKgsociF2OfjwMb2Xh2rgc
cRi23hQIedvGipnt+iHdYhgALfAUzFpOd57y6HcUAxTGqf2yEqBn/x83etBwj5bXcCQOLZ1FXjwA
E+6gOjEakCBXZeQwF8bJBHndHv+gyO9frAAlOgG/lpwElY6tUrORcPT07DPhDwgXgriGCj850dyQ
Occ+uTMpg9kK6BPgXj0NJYDEbM8sLoAq0C1ASRvEnLbzNikm7DEAcxrNd5Wt5SxL8RQpNugxXN71
XI92W6sB1s/nzSer9LRzUEI0JYdXWh5UmTubAerF3ZWjsHK27HChKqqF+vGpOJQVBwIDAQABo0Iw
QDAdBgNVHQ4EFgQUM1ulb3pVYCuBSyYUzHm/SrqLMr0wDgYDVR0PAQH/BAQDAgGGMA8GA1UdEwEB
/wQFMAMBAf8wDQYJKoZIhvcNAQELBQADggEBALYfYXiGvrV6cReK8ddFAhX3uiDF5ZNpJV4VcTlO
wdHY6HtDu40Z0cAg3+dNq4pdf4AgjY3vAmiK1QCcIbcFrOe3j7GUUz25bvj36IJV0SgkZYDlFsew
RAvThFJDI8ja+172AYbZN7/9brhQyA3mPHT6C26P8ozD31C3nyj4rlAcmsy+dm5K2vS1KDWhHXKR
dhog7zrIRJDAHQZ7sM24weayW09IFVojo2rJBlp8jIhEcYma52rePQmv0cu8lacIV45RoTER03Hw
g+9Qx+55bDsjY/iaZm4OKSAbrSXNubi/G9JzQADDTayJZPFzoIOJDhp0mKiUPLZ07JROAhXrMW4w
ggSSMIIDeqADAgECAgIC9TANBgkqhkiG9w0BAQsFADBNMQswCQYDVQQGEwJVUzEYMBYGA1UEChMP
VS5TLiBHb3Zlcm5tZW50MQwwCgYDVQQLEwNFQ0ExFjAUBgNVBAMTDUVDQSBSb290IENBIDQwHhcN
MTkwNTA3MTI1NTI4WhcNMjUwNTA3MTI1NTI4WjB1MQswCQYDVQQGEwJVUzEYMBYGA1UEChMPVS5T
LiBHb3Zlcm5tZW50MQwwCgYDVQQLEwNFQ0ExIjAgBgNVBAsTGUNlcnRpZmljYXRpb24gQXV0aG9y
aXRpZXMxGjAYBgNVBAMTEUlkZW5UcnVzdCBFQ0EgUzIyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEAt6DTxW5yDAER5mqwNjBumWj29f1myTOf5jY+hFnWGTHaJd/V9DcX12FxPaAgOsj8
q3k9NOOYIPQO6woEVFFf31rNmuE7b5lmhOtjGP8BUUOQIq0lBZxH+Kx6yXQ0gDtDZkpVQMDkxMOx
Ko8cRcc65DjecWG006CCLcTBN/nIhykX8cXlxIk8klIkkuC7j6ymjTnMHCAhKGpu1AbDIjyC+RhF
hkrhuYNsw9Bpqm941owaLCeiHky8K/mWLfYYv3Yysz6aUJcWdwZUoEStjClzMDPsRyJD9CbxQ0ZC
rSa1NK9HSGc0teT088t21uLDvkWBzGr7hCOPXJqQGZ4F3oS4IQIDAQABo4IBUjCCAU4wHwYDVR0j
BBgwFoAUM1ulb3pVYCuBSyYUzHm/SrqLMr0wHQYDVR0OBBYEFOikBAKeSdIV0aVfu+uUOQS7gilu
MA4GA1UdDwEB/wQEAwIBhjAzBgNVHSAELDAqMAwGCmCGSAFlAwIBDAQwDAYKYIZIAWUDAgEMBTAM
BgpghkgBZQMCAQwKMBIGA1UdEwEB/wQIMAYBAf8CAQAwDAYDVR0kBAUwA4ABADA3BgNVHR8EMDAu
MCygKqAohiZodHRwOi8vY3JsLmRpc2EubWlsL2NybC9FQ0FST09UQ0E0LmNybDBsBggrBgEFBQcB
AQRgMF4wOgYIKwYBBQUHMAKGLmh0dHA6Ly9jcmwuZGlzYS5taWwvaXNzdWVkdG8vRUNBUk9PVENB
NF9JVC5wN2MwIAYIKwYBBQUHMAGGFGh0dHA6Ly9vY3NwLmRpc2EubWlsMA0GCSqGSIb3DQEBCwUA
A4IBAQBIB/AYjrPQr2Jh/qkcECcjetqBrhU8SsNRI42IW2xdfRqBODnKxWDFkkBtfNd/8+g5/76e
6c8f0Zw9fn8UTqdMaU0H9ylZt9ngc8aM6BhcaOyK1ClZwHohTpZHemhlI8nw6o7VRgIWl8E0Om/A
OOuNxPOYJ1DeG4XfGKqbTMwXVLVYE1M9PO3kNQpVFiXzwtw5WxCoQjkXd6aq1PWWehMF+r54/O4+
Ycu/Gr5y66EEFPnqLKXjJnJcOVDzwQ/k/7sGpQW7kxHeY/+YbBVdG0R0MvCyKIBWgIwimt0viqqq
a3oOCnYP3J1vB7vu+GH9d1bZKB64WZGknXyHK3QS8DArMIIHqDCCBpCgAwIBAgIQQAFu/9vH1Hi9
faHFlIkOwDANBgkqhkiG9w0BAQsFADB1MQswCQYDVQQGEwJVUzEYMBYGA1UEChMPVS5TLiBHb3Zl
cm5tZW50MQwwCgYDVQQLEwNFQ0ExIjAgBgNVBAsTGUNlcnRpZmljYXRpb24gQXV0aG9yaXRpZXMx
GjAYBgNVBAMTEUlkZW5UcnVzdCBFQ0EgUzIyMB4XDTE5MTIxMzE1MjM0M1oXDTIyMTIxMjE1MjM0
M1owgZUxCzAJBgNVBAYTAlVTMRgwFgYDVQQKEw9VLlMuIEdvdmVybm1lbnQxDDAKBgNVBAsTA0VD
QTESMBAGA1UECxMJSWRlblRydXN0MRYwFAYDVQQLEw1Bcm9uZXRpY3MgTExDMTIwMAYDVQQDEylK
b2huIEFyb246QTAxMDlCMzAwMDAwMTZFQTg2RjNGMjMwMDAwMUQyNTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBALEOcknUWWvkkaX1oKZfNlKj3CgBICGb1GoeE1rnUQvcEDuVeAtP+zsW
5rxqusImavijhTwckMzo6QFNkUaInis462cAK+fDVL8btNBl0RatZuW6LJpFwYJBJ9mI5yXVAv+Q
tQ3USTwDU29OH5E4s1+SUrX31Ts2P+iq3nEc4XFNYjBn8KAeDBkJg9rrxvqZh5mxMpuUkDNfH+ZM
pVXVHvRk7sTYLYJXc6mG8EKk1tllw8czhaLvxQxse1w+PPWbVsluf2Bqv5eU1JvS5MXHnK2A/NmS
aa/chm46GdRr9Jh32rKCQcw+BCEa4HG4NyvibXiSD/OKasb6/U+xnIAjnsUCAwEAAaOCBBEwggQN
MA4GA1UdDwEB/wQEAwIFIDCCATEGCCsGAQUFBwEBBIIBIzCCAR8wKwYIKwYBBQUHMAGGH2h0dHA6
Ly9lY2FzMi5vY3NwLmlkZW50cnVzdC5jb20wgagGCCsGAQUFBzAChoGbbGRhcDovL2xkYXBlY2Eu
aWRlbnRydXN0LmNvbS9jbiUzRElkZW5UcnVzdCUyMEVDQSUyMFMyMiUyQ291JTNEQ2VydGlmaWNh
dGlvbiUyMEF1dGhvcml0aWVzJTJDb3UlM0RFQ0ElMkNvJTNEVS5TLiUyMEdvdmVybm1lbnQlMkNj
JTNEVVM/Y0FDZXJ0aWZpY2F0ZTtiaW5hcnkwRQYIKwYBBQUHMAKGOWh0dHA6Ly92YWxpZGF0aW9u
LmlkZW50cnVzdC5jb20vY2VydHMvaWRlbnRydXN0ZWNhczIyLmNlcjAfBgNVHSMEGDAWgBTopAQC
nknSFdGlX7vrlDkEu4IpbjAbBgNVHQkEFDASMBAGCCsGAQUFBwkEMQQTAlVTMIIBMwYDVR0gBIIB
KjCCASYwggEiBgpghkgBZQMCAQwFMIIBEjBLBggrBgEFBQcCARY/aHR0cHM6Ly9zZWN1cmUuaWRl
bnRydXN0LmNvbS9jZXJ0aWZpY2F0ZXMvcG9saWN5L2VjYS9pbmRleC5odG1sMIHCBggrBgEFBQcC
AjCBtQyBskNlcnRpZmljYXRlIHVzZSByZXN0cmljdGVkIHRvIFJlbHlpbmcgUGFydHkocykgaW4g
YWNjb3JkYW5jZSB3aXRoIEVDQS1DUCAoc2VlIGh0dHBzOi8vc2VjdXJlLmlkZW50cnVzdC5jb20v
Y2VydGlmaWNhdGVzL3BvbGljeS9FQ0EvaW5kZXguaHRtbCkuIEVDQS1DUFMgaW5jb3Jwb3JhdGVk
IGJ5IHJlZmVyZW5jZS4wgf0GA1UdHwSB9TCB8jCBsKCBraCBqoaBp2xkYXA6Ly9sZGFwZWNhLmlk
ZW50cnVzdC5jb20vY24lM0RJZGVuVHJ1c3QlMjBFQ0ElMjBTMjIlMkNvdSUzRENlcnRpZmljYXRp
b24lMjBBdXRob3JpdGllcyUyQ291JTNERUNBJTJDbyUzRFUuUy4lMjBHb3Zlcm5tZW50JTJDYyUz
RFVTP2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q7YmluYXJ5MD2gO6A5hjdodHRwOi8vdmFsaWRh
dGlvbi5pZGVudHJ1c3QuY29tL2NybC9pZGVudHJ1c3RlY2FzMjIuY3JsMB0GA1UdEQQWMBSBEmpv
aG5AYXJvbmV0aWNzLmNvbTAdBgNVHQ4EFgQUubvtwtL7mOqQ4xQAAHBOKiFE0VQwEwYDVR0lBAww
CgYIKwYBBQUHAwQwDQYJKoZIhvcNAQELBQADggEBAB3CQjE6kc6J1T0nCka4EQPQbHrrjEYcoY26
oX1gtxgpkmL7V3NakWycjwzLOIFD9PipfK61TT/j6UNvNHg2GUatdipfIZ+oXGEkq3LG16dOl/On
FpY6qTT2PF1hZUrUAPXTSq6syomsTzP4BNc02+X5BNNIn6302q63+RfjZFUUKEozP+XEFANxwccJ
Z6w9oB6w+nk+u55dCRmPxEw+6iPVEpn/V1BDt/9wu7GR6kbne0n9JUs0ChT6lGYsd1OZGyWb4L5i
BeZ8433zFdeaMQMgZNFEpzcYtTLOOV94KVdsQbEAVjuy5ys3LueB+TmHp54Sek2jm76gzVR8EF0F
os4wggf2MIIG3qADAgECAhBAAW7/3NMKJM1U1yqHjdeXMA0GCSqGSIb3DQEBCwUAMHUxCzAJBgNV
BAYTAlVTMRgwFgYDVQQKEw9VLlMuIEdvdmVybm1lbnQxDDAKBgNVBAsTA0VDQTEiMCAGA1UECxMZ
Q2VydGlmaWNhdGlvbiBBdXRob3JpdGllczEaMBgGA1UEAxMRSWRlblRydXN0IEVDQSBTMjIwHhcN
MTkxMjEzMTUyNDUyWhcNMjIxMjEyMTUyNDUyWjCBlTELMAkGA1UEBhMCVVMxGDAWBgNVBAoTD1Uu
Uy4gR292ZXJubWVudDEMMAoGA1UECxMDRUNBMRIwEAYDVQQLEwlJZGVuVHJ1c3QxFjAUBgNVBAsT
DUFyb25ldGljcyBMTEMxMjAwBgNVBAMTKUpvaG4gQXJvbjpBMDEwOUIzMDAwMDAxNkVBODZGM0Yy
MzAwMDAxRDI1MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAy3NpPOFjY6VLGiFUeCtC
iOyNmDyeV3lOnaDNRsdk603M+o6f+ZFinFnp2bvBt1WfOz4zGu2Nd7Mk5c788MOSk26M2KzpjS10
giyYYEaCDbBE9Z/owhySIRLVeSo1A6CiRHcTEBAaNfYpLGqXYXbELZDk2E1H5vmnVKcrWRxG2YZR
lxw4sAhLi8fmHQDvYPofsDKcebAUAbf7gpsMhtXFimCna3YgJvpGTR+BZ0ipONkp5wjz8l8V4b6g
1xFGdWufwEd0ct33ZY3BZVIaRypc3Jr3T6IcvjA4k9HwUzkcjSuCLe+So2ur7gTmY2FO6yoEDfIw
pBQU06QD5Pot7BnzdQIDAQABo4IEXzCCBFswDgYDVR0PAQH/BAQDAgbAMIIBMQYIKwYBBQUHAQEE
ggEjMIIBHzArBggrBgEFBQcwAYYfaHR0cDovL2VjYXMyLm9jc3AuaWRlbnRydXN0LmNvbTCBqAYI
KwYBBQUHMAKGgZtsZGFwOi8vbGRhcGVjYS5pZGVudHJ1c3QuY29tL2NuJTNESWRlblRydXN0JTIw
RUNBJTIwUzIyJTJDb3UlM0RDZXJ0aWZpY2F0aW9uJTIwQXV0aG9yaXRpZXMlMkNvdSUzREVDQSUy
Q28lM0RVLlMuJTIwR292ZXJubWVudCUyQ2MlM0RVUz9jQUNlcnRpZmljYXRlO2JpbmFyeTBFBggr
BgEFBQcwAoY5aHR0cDovL3ZhbGlkYXRpb24uaWRlbnRydXN0LmNvbS9jZXJ0cy9pZGVudHJ1c3Rl
Y2FzMjIuY2VyMB8GA1UdIwQYMBaAFOikBAKeSdIV0aVfu+uUOQS7giluMBsGA1UdCQQUMBIwEAYI
KwYBBQUHCQQxBBMCVVMwggEzBgNVHSAEggEqMIIBJjCCASIGCmCGSAFlAwIBDAUwggESMEsGCCsG
AQUFBwIBFj9odHRwczovL3NlY3VyZS5pZGVudHJ1c3QuY29tL2NlcnRpZmljYXRlcy9wb2xpY3kv
ZWNhL2luZGV4Lmh0bWwwgcIGCCsGAQUFBwICMIG1DIGyQ2VydGlmaWNhdGUgdXNlIHJlc3RyaWN0
ZWQgdG8gUmVseWluZyBQYXJ0eShzKSBpbiBhY2NvcmRhbmNlIHdpdGggRUNBLUNQIChzZWUgaHR0
cHM6Ly9zZWN1cmUuaWRlbnRydXN0LmNvbS9jZXJ0aWZpY2F0ZXMvcG9saWN5L0VDQS9pbmRleC5o
dG1sKS4gRUNBLUNQUyBpbmNvcnBvcmF0ZWQgYnkgcmVmZXJlbmNlLjCB/QYDVR0fBIH1MIHyMIGw
oIGtoIGqhoGnbGRhcDovL2xkYXBlY2EuaWRlbnRydXN0LmNvbS9jbiUzRElkZW5UcnVzdCUyMEVD
QSUyMFMyMiUyQ291JTNEQ2VydGlmaWNhdGlvbiUyMEF1dGhvcml0aWVzJTJDb3UlM0RFQ0ElMkNv
JTNEVS5TLiUyMEdvdmVybm1lbnQlMkNjJTNEVVM/Y2VydGlmaWNhdGVSZXZvY2F0aW9uTGlzdDti
aW5hcnkwPaA7oDmGN2h0dHA6Ly92YWxpZGF0aW9uLmlkZW50cnVzdC5jb20vY3JsL2lkZW50cnVz
dGVjYXMyMi5jcmwwVQYDVR0RBE4wTIESam9obkBhcm9uZXRpY3MuY29toDYGCisGAQQBgjcUAgOg
KAwmQTAxMDlCMzAwMDAwMTZFQTg2RjNGMjMwMDAwMUQyNUBET0RFQ0EwHQYDVR0OBBYEFNxheynV
IGu32/+BAJUls+Xd5lguMCkGA1UdJQQiMCAGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQC
AjANBgkqhkiG9w0BAQsFAAOCAQEAZ5P1oC44GLasrCz7mLzBbu8EcBtVK2drq7Kr0b1HBt/YS+MZ
egtyCcoQeutwheALquDsTm4BcaIBo5kxghOjm+cTQLPfthDbi7gjM36vdFtlysSiFjiPLgqWN+yA
uJjbdc3oXfE+FyPDbo8nMBJN8PQc2v77/OYPJ0UhYuvdsNt+t3NHhJVjDCOLuSEQAZw32D05nhiY
E/GmF2CLmWQMyuxKQVaT+H2bjp8/2MSqD0BWffXN7RJJWPIO1xhj6DVYJW93IYWTJwcomrK0GxFy
cR4+SQEkY+ImADwdNNxkHgCvU8ej4Jv2aFYVfVGZ8W4B7KumCFTYAdte8OgA2xwS7TGCA+QwggPg
AgEBMIGJMHUxCzAJBgNVBAYTAlVTMRgwFgYDVQQKEw9VLlMuIEdvdmVybm1lbnQxDDAKBgNVBAsT
A0VDQTEiMCAGA1UECxMZQ2VydGlmaWNhdGlvbiBBdXRob3JpdGllczEaMBgGA1UEAxMRSWRlblRy
dXN0IEVDQSBTMjICEEABbv/c0wokzVTXKoeN15cwCQYFKw4DAhoFAKCCAi8wGAYJKoZIhvcNAQkD
MQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjIxMjExMjI1NDA1WjAjBgkqhkiG9w0BCQQx
FgQURPQS9hi2rOAtqrOcJ3kGLL9DXgIwgZMGCSqGSIb3DQEJDzGBhTCBgjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAoGCCqGSIb3DQMHMAsGCWCGSAFlAwQBAjAOBggqhkiG9w0DAgICAIAwDQYI
KoZIhvcNAwICAUAwBwYFKw4DAhowCwYJYIZIAWUDBAIDMAsGCWCGSAFlAwQCAjALBglghkgBZQME
AgEwgZoGCSsGAQQBgjcQBDGBjDCBiTB1MQswCQYDVQQGEwJVUzEYMBYGA1UEChMPVS5TLiBHb3Zl
cm5tZW50MQwwCgYDVQQLEwNFQ0ExIjAgBgNVBAsTGUNlcnRpZmljYXRpb24gQXV0aG9yaXRpZXMx
GjAYBgNVBAMTEUlkZW5UcnVzdCBFQ0EgUzIyAhBAAW7/28fUeL19ocWUiQ7AMIGcBgsqhkiG9w0B
CRACCzGBjKCBiTB1MQswCQYDVQQGEwJVUzEYMBYGA1UEChMPVS5TLiBHb3Zlcm5tZW50MQwwCgYD
VQQLEwNFQ0ExIjAgBgNVBAsTGUNlcnRpZmljYXRpb24gQXV0aG9yaXRpZXMxGjAYBgNVBAMTEUlk
ZW5UcnVzdCBFQ0EgUzIyAhBAAW7/28fUeL19ocWUiQ7AMA0GCSqGSIb3DQEBAQUABIIBACv6N4HV
D0XZhAwNdmLk+JnlglGCfodM2MHHfXkflOtOUuM27+RBD9+rPho0UwkPQS5bPa2NJCSJtoEpRGX7
Ct1gcSAD/uDHvfGrd+H2lNFlH7lqMXuJo0mp/beFIc60Wn2HHiJqsjpBsYqNOApzANE+NaTCJI76
FwIwsrK7hrm2ze5kcT0JGGFsn0k1MM3RU8+vtwt1VUOjeGVu3gZoVdtOw9H7LzXslm/TEiyxZ1Dg
WpRfRGyCFX1QQquKyQC0it8DRYgjGY/DbhQDjD2hQbCNpaypbqcWA3C/LFfP2ZymWCLoSub9vzBh
wJwso2UfNCv+057DGBWCMYZqCgm9eI4AAAAAAAA=

------=_NextPart_000_00A2_01D90D89.8F51BE80--

