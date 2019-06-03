Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A54D332F9
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 17:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729124AbfFCPAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 11:00:20 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:62218 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729038AbfFCPAT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 11:00:19 -0400
Received: from nat-ies.mentorg.com ([192.94.31.2] helo=SVR-IES-MBX-04.mgc.mentorg.com)
        by relay1.mentorg.com with esmtps (TLSv1.2:ECDHE-RSA-AES256-SHA384:256)
        id 1hXoRT-0006XY-96 from Carsten_Schmid@mentor.com ; Mon, 03 Jun 2019 08:00:07 -0700
Received: from SVR-IES-MBX-03.mgc.mentorg.com (139.181.222.3) by
 SVR-IES-MBX-04.mgc.mentorg.com (139.181.222.4) with Microsoft SMTP Server
 (TLS) id 15.0.1320.4; Mon, 3 Jun 2019 16:00:03 +0100
Received: from SVR-IES-MBX-03.mgc.mentorg.com ([fe80::1072:fb6e:87f1:ed17]) by
 SVR-IES-MBX-03.mgc.mentorg.com ([fe80::1072:fb6e:87f1:ed17%22]) with mapi id
 15.00.1320.000; Mon, 3 Jun 2019 16:00:03 +0100
From:   "Schmid, Carsten" <Carsten_Schmid@mentor.com>
To:     Sasha Levin <sashal@kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Stable <stable@vger.kernel.org>, Stable <stable@vger.kernel.org>
Subject: AW: [PATCH 3/5] usb: xhci: avoid null pointer deref when bos field is
 NULL
Thread-Topic: [PATCH 3/5] usb: xhci: avoid null pointer deref when bos field
 is NULL
Thread-Index: AQHVEJHzdFut9W6npEKrmFpS3QjO6qaCDxyAgAgIjHQ=
Date:   Mon, 3 Jun 2019 15:00:03 +0000
Message-ID: <1559574003412.30745@mentor.com>
References: <1558524841-25397-4-git-send-email-mathias.nyman@linux.intel.com>,<20190529131455.C7A8C217D4@mail.kernel.org>
In-Reply-To: <20190529131455.C7A8C217D4@mail.kernel.org>
Accept-Language: de-DE, en-IE, en-US
Content-Language: de-DE
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [137.202.0.90]
Content-Type: multipart/mixed; boundary="_002_155957400341230745mentorcom_"
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--_002_155957400341230745mentorcom_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Sasha,=0A=
=0A=
i have (back)ported the patch to the older kernels mentioned below=0A=
where the original patch failed.=0A=
=0A=
The patch appended to this mail applies to v4.14.121, v4.9.178, v4.4.180 an=
d v3.18.140.=0A=
Some changes within the xhci driver prevented git from finding the correct =
position.=0A=
=0A=
Hope this helps :-)=0A=
=0A=
Best regards=0A=
Carsten=0A=
=0A=
________________________________________=0A=
Von: Sasha Levin <sashal@kernel.org>=0A=
Gesendet: Mittwoch, 29. Mai 2019 15:14=0A=
An: Sasha Levin; Mathias Nyman; Schmid, Carsten; gregkh@linuxfoundation.org=
=0A=
Cc: linux-usb@vger.kernel.org; Stable; stable@vger.kernel.org=0A=
Betreff: Re: [PATCH 3/5] usb: xhci: avoid null pointer deref when bos field=
 is NULL=0A=
=0A=
Hi,=0A=
=0A=
[This is an automated email]=0A=
=0A=
This commit has been processed because it contains a -stable tag.=0A=
The stable tag indicates that it's relevant for the following trees: all=0A=
=0A=
The bot has tested the following trees: v5.1.4, v5.0.18, v4.19.45, v4.14.12=
1, v4.9.178, v4.4.180, v3.18.140.=0A=
=0A=
v5.1.4: Build OK!=0A=
v5.0.18: Build OK!=0A=
v4.19.45: Build OK!=0A=
v4.14.121: Failed to apply! Possible dependencies:=0A=
    01451ad47e272 ("powerpc/powermac: Use setup_timer() helper")=0A=
    38986ffa6a748 ("xhci: use port structures instead of port arrays in xhc=
i.c functions")=0A=
    83ad1e6a1dc04 ("powerpc/oprofile: Use setup_timer() helper")=0A=
    8d6b1bf20f61c ("powerpc/6xx: Use setup_timer() helper")=0A=
    b1fc2839d2f92 ("drm/msm: Implement preemption for A5XX targets")=0A=
    b9eaf18722221 ("treewide: init_timer() -> setup_timer()")=0A=
    cd414f3d93168 ("drm/msm: Move memptrs to msm_gpu")=0A=
    e629cfa36ea08 ("MIPS: Lasat: Use setup_timer() helper")=0A=
    e99e88a9d2b06 ("treewide: setup_timer() -> timer_setup()")=0A=
    eec874ce5ff1f ("drm/msm/adreno: load gpu at probe/bind time")=0A=
    f7de15450e906 ("drm/msm: Add per-instance submit queues")=0A=
    f97decac5f4c2 ("drm/msm: Support multiple ringbuffers")=0A=
=0A=
v4.9.178: Failed to apply! Possible dependencies:=0A=
    01451ad47e272 ("powerpc/powermac: Use setup_timer() helper")=0A=
    38986ffa6a748 ("xhci: use port structures instead of port arrays in xhc=
i.c functions")=0A=
    53460c53b7619 ("[media] au0828: Add timer to restart TS stream if no da=
ta arrives on bulk endpoint")=0A=
    7c96f59e0cafe ("[media] s5p-mfc: Fix initialization of internal structu=
res")=0A=
    83ad1e6a1dc04 ("powerpc/oprofile: Use setup_timer() helper")=0A=
    8d6b1bf20f61c ("powerpc/6xx: Use setup_timer() helper")=0A=
    b9eaf18722221 ("treewide: init_timer() -> setup_timer()")=0A=
    cf43e6be865a5 ("block: add scalable completion tracking of requests")=
=0A=
    e629cfa36ea08 ("MIPS: Lasat: Use setup_timer() helper")=0A=
    e806402130c9c ("block: split out request-only flags into a new namespac=
e")=0A=
    e99e88a9d2b06 ("treewide: setup_timer() -> timer_setup()")=0A=
=0A=
v4.4.180: Failed to apply! Possible dependencies:=0A=
    01451ad47e272 ("powerpc/powermac: Use setup_timer() helper")=0A=
    37f895d7e85e7 ("NFC: pn533: Fix socket deadlock")=0A=
    38986ffa6a748 ("xhci: use port structures instead of port arrays in xhc=
i.c functions")=0A=
    53460c53b7619 ("[media] au0828: Add timer to restart TS stream if no da=
ta arrives on bulk endpoint")=0A=
    7c96f59e0cafe ("[media] s5p-mfc: Fix initialization of internal structu=
res")=0A=
    80c1bce9aa315 ("[media] au0828: Refactoring for start_urb_transfer()")=
=0A=
    83ad1e6a1dc04 ("powerpc/oprofile: Use setup_timer() helper")=0A=
    8d6b1bf20f61c ("powerpc/6xx: Use setup_timer() helper")=0A=
    9815c7cf22dac ("NFC: pn533: Separate physical layer from the core imple=
mentation")=0A=
    b9eaf18722221 ("treewide: init_timer() -> setup_timer()")=0A=
    e629cfa36ea08 ("MIPS: Lasat: Use setup_timer() helper")=0A=
    e997ebbe46fe4 ("NFC: pn533: Send ATR_REQ only if NFC_PROTO_NFC_DEP bit =
is set")=0A=
    e99e88a9d2b06 ("treewide: setup_timer() -> timer_setup()")=0A=
=0A=
v3.18.140: Failed to apply! Possible dependencies:=0A=
    0a5942c8e1480 ("NFC: Add ACPI support for NXP PN544")=0A=
    34ac49664149d ("NFC: nci: remove current SLEEP mode management")=0A=
    3590ebc040c9e ("NFC: logging neatening")=0A=
    3682f49f32051 ("NFC: netlink: Add new netlink command NFC_CMD_ACTIVATE_=
TARGET")=0A=
    37f895d7e85e7 ("NFC: pn533: Fix socket deadlock")=0A=
    38986ffa6a748 ("xhci: use port structures instead of port arrays in xhc=
i.c functions")=0A=
    53460c53b7619 ("[media] au0828: Add timer to restart TS stream if no da=
ta arrives on bulk endpoint")=0A=
    5df848f37b1d2 ("NFC: pn533: fix error return code")=0A=
    7c96f59e0cafe ("[media] s5p-mfc: Fix initialization of internal structu=
res")=0A=
    80c1bce9aa315 ("[media] au0828: Refactoring for start_urb_transfer()")=
=0A=
    9295b5b569fc4 ("NFC: nci: Add support for different NCI_DEACTIVATE_TYPE=
")=0A=
    96d4581f0b371 ("NFC: netlink: Add mode parameter to deactivate_target f=
unctions")=0A=
    9815c7cf22dac ("NFC: pn533: Separate physical layer from the core imple=
mentation")=0A=
    b9eaf18722221 ("treewide: init_timer() -> setup_timer()")=0A=
    d7979e130ebb0 ("NFC: NCI: Signal deactivation in Target mode")=0A=
    e997ebbe46fe4 ("NFC: pn533: Send ATR_REQ only if NFC_PROTO_NFC_DEP bit =
is set")=0A=
    e99e88a9d2b06 ("treewide: setup_timer() -> timer_setup()")=0A=
=0A=
=0A=
How should we proceed with this patch?=0A=
=0A=
--=0A=
Thanks,=0A=
Sasha=0A=

--_002_155957400341230745mentorcom_
Content-Type: application/octet-stream;
	name="0001-usb-xhci-avoid-null-pointer-deref-when-bos-field-is-.patch.4.14"
Content-Description: 0001-usb-xhci-avoid-null-pointer-deref-when-bos-field-is-.patch.4.14
Content-Disposition: attachment;
	filename="0001-usb-xhci-avoid-null-pointer-deref-when-bos-field-is-.patch.4.14";
	size=4900; creation-date="Mon, 03 Jun 2019 14:59:38 GMT";
	modification-date="Mon, 03 Jun 2019 14:59:38 GMT"
Content-Transfer-Encoding: base64

RnJvbSBiMWNlYjM3ODdiY2Q2ZjNhZTc3NWVlYmVhZDlhNjZiODBhMmI0MzE0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBDYXJzdGVuIFNjaG1pZCA8Y2Fyc3Rlbl9zY2htaWRAbWVudG9y
LmNvbT4KRGF0ZTogRnJpLCA4IE1hciAyMDE5IDE1OjE1OjUyICswMTAwClN1YmplY3Q6IFtQQVRD
SF0gdXNiOiB4aGNpOiBhdm9pZCBudWxsIHBvaW50ZXIgZGVyZWYgd2hlbiBib3MgZmllbGQgaXMg
TlVMTAoKV2l0aCBkZWZlY3RpdmUgVVNCIHN0aWNrcyB3ZSBzZWUgdGhlIGZvbGxvd2luZyBlcnJv
ciBoYXBwZW46CnVzYiAxLTM6IG5ldyBoaWdoLXNwZWVkIFVTQiBkZXZpY2UgbnVtYmVyIDYgdXNp
bmcgeGhjaV9oY2QKdXNiIDEtMzogZGV2aWNlIGRlc2NyaXB0b3IgcmVhZC82NCwgZXJyb3IgLTcx
CnVzYiAxLTM6IGRldmljZSBkZXNjcmlwdG9yIHJlYWQvNjQsIGVycm9yIC03MQp1c2IgMS0zOiBu
ZXcgaGlnaC1zcGVlZCBVU0IgZGV2aWNlIG51bWJlciA3IHVzaW5nIHhoY2lfaGNkCnVzYiAxLTM6
IGRldmljZSBkZXNjcmlwdG9yIHJlYWQvNjQsIGVycm9yIC03MQp1c2IgMS0zOiB1bmFibGUgdG8g
Z2V0IEJPUyBkZXNjcmlwdG9yIHNldAp1c2IgMS0zOiBOZXcgVVNCIGRldmljZSBmb3VuZCwgaWRW
ZW5kb3I9MDc4MSwgaWRQcm9kdWN0PTU1ODEKdXNiIDEtMzogTmV3IFVTQiBkZXZpY2Ugc3RyaW5n
czogTWZyPTEsIFByb2R1Y3Q9MiwgU2VyaWFsTnVtYmVyPTMKLi4uCkJVRzogdW5hYmxlIHRvIGhh
bmRsZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0IDAwMDAwMDAwMDAwMDAwMDgK
ClRoaXMgY29tZXMgZnJvbSB0aGUgZm9sbG93aW5nIHBsYWNlOgpbIDE2NjAuMjE1MzgwXSBJUDog
eGhjaV9zZXRfdXNiMl9oYXJkd2FyZV9scG0rMHhkZi8weDNkMCBbeGhjaV9oY2RdClsgMTY2MC4y
MjIwOTJdIFBHRCAwIFA0RCAwClsgMTY2MC4yMjQ5MThdIE9vcHM6IDAwMDAgWyMxXSBQUkVFTVBU
IFNNUCBOT1BUSQpbIDE2NjAuNDI1NTIwXSBDUFU6IDEgUElEOiAzOCBDb21tOiBrd29ya2VyLzE6
MSBUYWludGVkOiBQICAgICBVICBXICBPICAgIDQuMTQuNjctYXBsICMxClsgMTY2MC40MzQyNzdd
IFdvcmtxdWV1ZTogdXNiX2h1Yl93cSBodWJfZXZlbnQgW3VzYmNvcmVdClsgMTY2MC40Mzk5MThd
IHRhc2s6IGZmZmZhMjk1YjZhZTRjODAgdGFzay5zdGFjazogZmZmZmFkNDU4MDE1MDAwMApbIDE2
NjAuNDQ2NTMyXSBSSVA6IDAwMTA6eGhjaV9zZXRfdXNiMl9oYXJkd2FyZV9scG0rMHhkZi8weDNk
MCBbeGhjaV9oY2RdClsgMTY2MC40NTM4MjFdIFJTUDogMDAxODpmZmZmYWQ0NTgwMTUzYzcwIEVG
TEFHUzogMDAwMTAwNDYKWyAxNjYwLjQ1OTY1NV0gUkFYOiAwMDAwMDAwMDAwMDAwMDAwIFJCWDog
ZmZmZmEyOTViNGQ3YzAwMCBSQ1g6IDAwMDAwMDAwMDAwMDAwMDIKWyAxNjYwLjQ2NzYyNV0gUkRY
OiAwMDAwMDAwMDAwMDAwMDAyIFJTSTogZmZmZmZmZmY5ODRhNTViMiBSREk6IGZmZmZmZmZmOTg0
YTU1YjIKWyAxNjYwLjQ3NTU4Nl0gUkJQOiBmZmZmYWQ0NTgwMTUzY2M4IFIwODogMDAwMDAwMDAw
MGQ2NTIwYSBSMDk6IDAwMDAwMDAwMDAwMDAwMDEKWyAxNjYwLjQ4MzU1Nl0gUjEwOiBmZmZmYWQ0
NTgwYTAwNGEwIFIxMTogMDAwMDAwMDAwMDAwMDI4NiBSMTI6IGZmZmZhMjk1YjRkN2MwMDAKWyAx
NjYwLjQ5MTUyNV0gUjEzOiAwMDAwMDAwMDAwMDEwNjQ4IFIxNDogZmZmZmEyOTVhODRlMTgwMCBS
MTU6IDAwMDAwMDAwMDAwMDAwMDAKWyAxNjYwLjQ5OTQ5NF0gRlM6ICAwMDAwMDAwMDAwMDAwMDAw
KDAwMDApIEdTOmZmZmZhMjk1YmZjODAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApb
IDE2NjAuNTA4NTMwXSBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgw
MDUwMDMzClsgMTY2MC41MTQ5NDddIENSMjogMDAwMDAwMDAwMDAwMDAwOCBDUjM6IDAwMDAwMDAy
NWExMTQwMDAgQ1I0OiAwMDAwMDAwMDAwMzQwNmEwClsgMTY2MC41MjI5MTddIENhbGwgVHJhY2U6
ClsgMTY2MC41MjU2NTddICB1c2Jfc2V0X3VzYjJfaGFyZHdhcmVfbHBtKzB4M2QvMHg3MCBbdXNi
Y29yZV0KWyAxNjYwLjUzMTc5Ml0gIHVzYl9kaXNhYmxlX2RldmljZSsweDI0Mi8weDI2MCBbdXNi
Y29yZV0KWyAxNjYwLjUzNzQzOV0gIHVzYl9kaXNjb25uZWN0KzB4YzEvMHgyYjAgW3VzYmNvcmVd
ClsgMTY2MC41NDI2MDBdICBodWJfZXZlbnQrMHg1OTYvMHgxOGYwIFt1c2Jjb3JlXQpbIDE2NjAu
NTQ3NDY3XSAgPyB0cmFjZV9wcmVlbXB0X29uKzB4ZGYvMHgxMDAKWyAxNjYwLjU1MjA0MF0gID8g
cHJvY2Vzc19vbmVfd29yaysweDFjMS8weDQxMApbIDE2NjAuNTU2NzA4XSAgcHJvY2Vzc19vbmVf
d29yaysweDFkMi8weDQxMApbIDE2NjAuNTYxMTg0XSAgPyBwcmVlbXB0X2NvdW50X2FkZC5wYXJ0
LjMrMHgyMS8weDYwClsgMTY2MC41NjY0MzZdICB3b3JrZXJfdGhyZWFkKzB4MmQvMHgzZjAKWyAx
NjYwLjU3MDUyMl0gIGt0aHJlYWQrMHgxMjIvMHgxNDAKWyAxNjYwLjU3NDEyM10gID8gcHJvY2Vz
c19vbmVfd29yaysweDQxMC8weDQxMApbIDE2NjAuNTc4NzkyXSAgPyBrdGhyZWFkX2NyZWF0ZV9v
bl9ub2RlKzB4NjAvMHg2MApbIDE2NjAuNTgzODQ5XSAgcmV0X2Zyb21fZm9yaysweDNhLzB4NTAK
WyAxNjYwLjU4NzgzOV0gQ29kZTogMDAgNDkgODkgYzMgNDkgOGIgODQgMjQgNTAgMTYgMDAgMDAg
OGQgNGEgZmYgNDggOGQgMDQgYzggNDggODkgY2EgNGMgOGIgMTAgNDUgOGIgNmEgMDQgNDggOGIg
MDAgNDggODkgNDUgYzAgNDkgOGIgODYgODAgMDMgMDAgMDAgPDQ4PiA4YiA0MCAwOCA4YiA0MCAw
MyAwZiAxZiA0NCAwMCAwMCA0NSA4NSBmZiAwZiA4NCA4MSAwMSAwMCAwMApbIDE2NjAuNjA4OTgw
XSBSSVA6IHhoY2lfc2V0X3VzYjJfaGFyZHdhcmVfbHBtKzB4ZGYvMHgzZDAgW3hoY2lfaGNkXSBS
U1A6IGZmZmZhZDQ1ODAxNTNjNzAKWyAxNjYwLjYxNzkyMV0gQ1IyOiAwMDAwMDAwMDAwMDAwMDA4
CgpUcmFja2luZyB0aGlzIGRvd24gc2hvd3MgdGhhdCB1ZGV2LT5ib3MgaXMgTlVMTCBpbiB0aGUg
Zm9sbG93aW5nIGNvZGU6Cih4aGNpLmMsIGluIHhoY2lfc2V0X3VzYjJfaGFyZHdhcmVfbHBtKQoJ
ZmllbGQgPSBsZTMyX3RvX2NwdSh1ZGV2LT5ib3MtPmV4dF9jYXAtPmJtQXR0cmlidXRlcyk7ICA8
PDw8PDw8IGhlcmUKCgl4aGNpX2RiZyh4aGNpLCAiJXMgcG9ydCAlZCBVU0IyIGhhcmR3YXJlIExQ
TVxuIiwKCQkJZW5hYmxlID8gImVuYWJsZSIgOiAiZGlzYWJsZSIsIHBvcnRfbnVtICsgMSk7CgoJ
aWYgKGVuYWJsZSkgewoJCS8qIEhvc3Qgc3VwcG9ydHMgQkVTTCB0aW1lb3V0IGluc3RlYWQgb2Yg
SElSRCAqLwoJCWlmICh1ZGV2LT51c2IyX2h3X2xwbV9iZXNsX2NhcGFibGUpIHsKCQkJLyogaWYg
ZGV2aWNlIGRvZXNuJ3QgaGF2ZSBhIHByZWZlcnJlZCBCRVNMIHZhbHVlIHVzZSBhCgkJCSAqIGRl
ZmF1bHQgb25lIHdoaWNoIHdvcmtzIHdpdGggbWl4ZWQgSElSRCBhbmQgQkVTTAoJCQkgKiBzeXN0
ZW1zLiBTZWUgWEhDSV9ERUZBVUxUX0JFU0wgZGVmaW5pdGlvbiBpbiB4aGNpLmgKCQkJICovCgkJ
CWlmICgoZmllbGQgJiBVU0JfQkVTTF9TVVBQT1JUKSAmJgoJCQkgICAgKGZpZWxkICYgVVNCX0JF
U0xfQkFTRUxJTkVfVkFMSUQpKQoJCQkJaGlyZCA9IFVTQl9HRVRfQkVTTF9CQVNFTElORShmaWVs
ZCk7CgkJCWVsc2UKCQkJCWhpcmQgPSB1ZGV2LT5sMV9wYXJhbXMuYmVzbDsKClRoZSBmYWlsaW5n
IGNhc2UgaXMgd2hlbiBkaXNhYmxpbmcgTFBNLiBTbyBpdCBpcyBzdWZmaWNpZW50IHRvIGF2b2lk
CmFjY2VzcyB0byB1ZGV2LT5ib3MgYnkgbW92aW5nIHRoZSBpbnN0cnVjdGlvbiBpbnRvIHRoZSAi
ZW5hYmxlIiBjbGF1c2UuCgpTaWduZWQtb2ZmLWJ5OiBDYXJzdGVuIFNjaG1pZCA8Y2Fyc3Rlbl9z
Y2htaWRAbWVudG9yLmNvbT4KLS0tCiBkcml2ZXJzL3VzYi9ob3N0L3hoY2kuYyB8IDIgKy0KIDEg
ZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBh
L2RyaXZlcnMvdXNiL2hvc3QveGhjaS5jIGIvZHJpdmVycy91c2IvaG9zdC94aGNpLmMKaW5kZXgg
Yzc4ZGUwN2M0ZDAwLi42MDAxYzNjZWZhYjMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvdXNiL2hvc3Qv
eGhjaS5jCisrKyBiL2RyaXZlcnMvdXNiL2hvc3QveGhjaS5jCkBAIC00MTU1LDcgKzQxNTUsNiBA
QCBzdGF0aWMgaW50IHhoY2lfc2V0X3VzYjJfaGFyZHdhcmVfbHBtKHN0cnVjdCB1c2JfaGNkICpo
Y2QsCiAJcG1fYWRkciA9IHBvcnRfYXJyYXlbcG9ydF9udW1dICsgUE9SVFBNU0M7CiAJcG1fdmFs
ID0gcmVhZGwocG1fYWRkcik7CiAJaGxwbV9hZGRyID0gcG9ydF9hcnJheVtwb3J0X251bV0gKyBQ
T1JUSExQTUM7Ci0JZmllbGQgPSBsZTMyX3RvX2NwdSh1ZGV2LT5ib3MtPmV4dF9jYXAtPmJtQXR0
cmlidXRlcyk7CiAKIAl4aGNpX2RiZyh4aGNpLCAiJXMgcG9ydCAlZCBVU0IyIGhhcmR3YXJlIExQ
TVxuIiwKIAkJCWVuYWJsZSA/ICJlbmFibGUiIDogImRpc2FibGUiLCBwb3J0X251bSArIDEpOwpA
QCAtNDE2Nyw2ICs0MTY2LDcgQEAgc3RhdGljIGludCB4aGNpX3NldF91c2IyX2hhcmR3YXJlX2xw
bShzdHJ1Y3QgdXNiX2hjZCAqaGNkLAogCQkJICogZGVmYXVsdCBvbmUgd2hpY2ggd29ya3Mgd2l0
aCBtaXhlZCBISVJEIGFuZCBCRVNMCiAJCQkgKiBzeXN0ZW1zLiBTZWUgWEhDSV9ERUZBVUxUX0JF
U0wgZGVmaW5pdGlvbiBpbiB4aGNpLmgKIAkJCSAqLworCQkJZmllbGQgPSBsZTMyX3RvX2NwdSh1
ZGV2LT5ib3MtPmV4dF9jYXAtPmJtQXR0cmlidXRlcyk7CiAJCQlpZiAoKGZpZWxkICYgVVNCX0JF
U0xfU1VQUE9SVCkgJiYKIAkJCSAgICAoZmllbGQgJiBVU0JfQkVTTF9CQVNFTElORV9WQUxJRCkp
CiAJCQkJaGlyZCA9IFVTQl9HRVRfQkVTTF9CQVNFTElORShmaWVsZCk7Ci0tIAoyLjE3LjEKCg==

--_002_155957400341230745mentorcom_--
