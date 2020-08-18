Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693AD247EC8
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 08:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgHRG5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 02:57:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726228AbgHRG47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 02:56:59 -0400
Received: from saruman (unknown [85.206.163.145])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C938220639;
        Tue, 18 Aug 2020 06:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597733819;
        bh=b0DcgzAO/FotIJkO9ER4sAW02nmMq8dbhqQ3phtzeGk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ig5we8dAV4MNPkkqogN0Q3cVOwIU5GDNau4yLML55D7WNxom6P4aqeGSYdzrKo+oA
         HZbq94ejoZFIZl1aGeo0tZ/g1891a7+xgz3dTHAKp+S+VcRTawf4/mlx19tf1krfKK
         xIaxCBrYUcJp/gjeC74+nwOCAfwHhaxfpM0S3gys=
From:   Felipe Balbi <balbi@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Cc:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 0/3] usb: dwc3: gadget: Fix halt/clear_stall handling
In-Reply-To: <988d2d58-59f6-3d1e-bc66-ab424cc0fff4@synopsys.com>
References: <cover.1596151437.git.thinhn@synopsys.com>
 <988d2d58-59f6-3d1e-bc66-ab424cc0fff4@synopsys.com>
Date:   Tue, 18 Aug 2020 09:56:41 +0300
Message-ID: <87364kzbkm.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Thinh Nguyen <Thinh.Nguyen@synopsys.com> writes:

> Hi Felipe,
>
> Thinh Nguyen wrote:
>> This series fixes a couple of driver issues handling ClearFeature(halt)
>> request:
>>
>> 1) A function driver often uses set_halt() to reject a class driver prot=
ocol
>> command. After set_halt(), the endpoint will be stalled. It can queue new
>> requests while the endpoint is stalled. However, dwc3 currently drops th=
ose
>> requests after CLEAR_STALL. The driver should only drop started requests=
. Keep
>> the pending requests in the pending list to resume and process them afte=
r the
>> host issues ClearFeature(Halt) to the endpoint.
>>
>> 2) DWC3 should issue CLEAR_STALL command _after_ END_TRANSFER command co=
mpletes.
>>
>>
>> Thinh Nguyen (3):
>>   usb: dwc3: gadget: Resume pending requests after CLEAR_STALL
>>   usb: dwc3: gadget: END_TRANSFER before CLEAR_STALL command
>
> Since you're picking the fix patches for RC cycle, can you pick up these
> 2 patches of this series also? We can leave the refactoring patch in
> this series for v5.10.

just to be sure: you did run these through usbcv and usb3 compliance
suite, right? Which gadget drivers did you use?

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAl87e6kRHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQYkQhAAqmt387pE4WPQmp4CQ4sqMtaw8AosnrbB
oxQdvTeF0+rQ8dRZEGA5NYyWaZDNSMI0ZxX0AKGOeqrRFOBYmHy44LzWXu9SbouF
/Q2cwQ29IT9UMjJWlL8UYHf+dAEACPKZ2Pw3zduADl6QX2TYLRxTVE/cpK17HbgH
9mRIdsOgHHzKDZ9yBmmfH3AmoO6aQ+XhWCYe3C9oWRwEvI6ECwSVlbCNvugCPLQJ
Jr41XFyg/Qex5rvhD6CD+oa/dAJ12RghWfyaz4VPQ5B7E74TJr/thak/P6I9HuTF
2p+4GApLkBmO2Wl8UNN+cB/A92P24dHkwTBbQlAoxM4AGdG6cgQPf8ac5pYO6Kcy
FGY3L+LcxBFcwjX+8cyspAJrxNEgo3eRysIO/CyyW73FyzgRzPKDafqy04fAQSNb
mP0GpkDmp4QNx2E01QO67nrEFRazsFUNlG2HEruOW031LY1tNsw6cgUvqRdejvNU
J4XIIgtrPzAXsX47bQ1MGavqDXlf8hBnFiHwh4zxsc61wDTg0yXDX6w8Hj1WowZU
hL575WGG8a7FcISTiqtyQbOkePF/of5dD6Z+I7fxDxw8BiHlyb5uUd1fVW2MZH6+
n3/5MWH3UqhVITmP4BJVWyWJrvm4ROJeqM6KF2m0PdF+uJG/FA1qWHZHwl+Pt83/
YZavKE5V79w=
=V81P
-----END PGP SIGNATURE-----
--=-=-=--
