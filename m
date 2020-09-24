Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBAD276AB5
	for <lists+stable@lfdr.de>; Thu, 24 Sep 2020 09:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgIXHYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Sep 2020 03:24:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726993AbgIXHYr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Sep 2020 03:24:47 -0400
Received: from saruman (91-155-214-58.elisa-laajakaista.fi [91.155.214.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5633A20936;
        Thu, 24 Sep 2020 07:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600932287;
        bh=e5lSVSXzQap1k+VqyQ5fAgLcizbeQMwg6tpYahSgj5I=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=BlzZq5BkLud9A6W69jaUWto6aUveafm+dgtEz4DUsXStsZ+bitFPxRX161WQldDR2
         1pyQa43lAN7f5+vRrLS5T23SMxTuejR1P/ZCrvhrmPVnXT8eUxcmAXEUWpnDHdTi+7
         oiGgba4luUnGcDK/jb+x8y2vk804TTzwDLIkH5xs=
From:   Felipe Balbi <balbi@kernel.org>
To:     Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     linux-usb@vger.kernel.org, Raymond Tan <raymond.tan@intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: dwc3: pci: Allow Elkhart Lake to utilize DSM
 method for PM functionality
In-Reply-To: <20200914121425.GA810499@kuha.fi.intel.com>
References: <20200821131101.81915-1-heikki.krogerus@linux.intel.com>
 <20200914121425.GA810499@kuha.fi.intel.com>
Date:   Thu, 24 Sep 2020 10:24:40 +0300
Message-ID: <87lfgzeix3.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Heikki Krogerus <heikki.krogerus@linux.intel.com> writes:

> Hi Felipe,
>
> On Fri, Aug 21, 2020 at 04:11:01PM +0300, Heikki Krogerus wrote:
>> From: Raymond Tan <raymond.tan@intel.com>
>>=20
>> Similar to some other IA platforms, Elkhart Lake too depends on the
>> PMU register write to request transition of Dx power state.
>>=20
>> Thus, we add the PCI_DEVICE_ID_INTEL_EHLLP to the list of devices that
>> shall execute the ACPI _DSM method during D0/D3 sequence.
>>a=20
>> [heikki.krogerus@linux.intel.com: included Fixes tag]
>>=20
>> Fixes: dbb0569de852 ("usb: dwc3: pci: Add Support for Intel Elkhart Lake=
 Devices")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Raymond Tan <raymond.tan@intel.com>
>> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>> ---
>>  drivers/usb/dwc3/dwc3-pci.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
>> index f5a61f57c74f0..242b6210380a4 100644
>> --- a/drivers/usb/dwc3/dwc3-pci.c
>> +++ b/drivers/usb/dwc3/dwc3-pci.c
>> @@ -147,7 +147,8 @@ static int dwc3_pci_quirks(struct dwc3_pci *dwc)
>>=20=20
>>  	if (pdev->vendor =3D=3D PCI_VENDOR_ID_INTEL) {
>>  		if (pdev->device =3D=3D PCI_DEVICE_ID_INTEL_BXT ||
>> -				pdev->device =3D=3D PCI_DEVICE_ID_INTEL_BXT_M) {
>> +		    pdev->device =3D=3D PCI_DEVICE_ID_INTEL_BXT_M ||
>> +		    pdev->device =3D=3D PCI_DEVICE_ID_INTEL_EHLLP) {
>>  			guid_parse(PCI_INTEL_BXT_DSM_GUID, &dwc->guid);
>>  			dwc->has_dsm_for_pm =3D true;
>>  		}
>
> I think this has gone under your radar. Let me know if you want
> anything to be changed.

Applied

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAl9sSbgRHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQaF9A//T2bowLR5rJdU8xgZERPCmwQJCeLUpjwf
OSo69oojNh2NN5CP70oOLSX+aBx6qsyFQfKlSGMfC+aaMwReFEWAUUVu1ZuttwJH
wGeatcsWuTLJVtUqBPJyeS9YNoNjuqqwdIuDnlc3xbigtvJtTIWctqcFE96lmeot
Yme8gYGAdHRyg/O3lZ3Rps2q+7yxYmq7VPaFHDNjAnUcjZFK4nHAWb3BPM52yhvI
ssqbM8ZVkjgaCInIefHQUN9U9Fpft9zj01WBRkHDyZ7oHqNqML3S17ACOR+LW4lp
AzGfnOjofnzGNF6i8napxQB8wSI0pjBF7lC4hdhHLchnSyfmbse6jn7/b2QXum3K
77gmPXvsDLmKjDscAgmgZl9OHL7uydnDqAZaRjIGHcXlExwDSxIWH4gtKGjU8gUD
9IJRetrZYngkyFR4IuF25brf2t4KaHLOsnZydhb28yvlOU+2JNQZMpO9/ehRsMUo
FjtYOKVqa0IlfrnoZD6wkqn4hnexbT2AP8o3VeaU4WSzxX434OfitLmT6faVQQy0
c/8AORuVvIcUyAktfPf41O7Pn9lowZlSnma9ylTJJE9aIggoYdOJdJJgw8du8nLI
pYL3Eg1Yp5yYvYr8sDE+vlsXcBMHHrOjog0gW4ISVVyhFormDgaGFrsPS0gYiYoE
iwLP5uwPwZQ=
=JgyS
-----END PGP SIGNATURE-----
--=-=-=--
