Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE5E19A9B7
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 12:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgDAKjz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 1 Apr 2020 06:39:55 -0400
Received: from esa1.mentor.iphmx.com ([68.232.129.153]:47385 "EHLO
        esa1.mentor.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbgDAKjz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 06:39:55 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Apr 2020 06:39:54 EDT
IronPort-SDR: 2+Wnbrzbre05ppiOcIM3FCzHJ9OT9b+XKhX4TWmJIeOsqv/2JezaZyp035IvaF9m98dtudgyHn
 0XiosnMCSoN8ibuFiL+6E/lVdkoT7VBYxfWreAsRq8g356DTrD0AYl/CjEsBZxtZZDFRsdYNmL
 sR4Hl8m7wgibm3YSWWX/OQ1P3f0N6OahDMeb4XDj7vE6t9kenZzDx271OSIn0i5fONkscrK6kt
 ZVXTZgBAVGbmPQLSQr7D2DOiiFLRXWqcs7mepwBnUqA7mH8yvTgzcwwKOmbZo4KwPVFDkS1dxf
 w+g=
X-IronPort-AV: E=Sophos;i="5.72,331,1580803200"; 
   d="scan'208";a="49302087"
Received: from orw-gwy-01-in.mentorg.com ([192.94.38.165])
  by esa1.mentor.iphmx.com with ESMTP; 01 Apr 2020 02:32:46 -0800
IronPort-SDR: qBqKXzkn/m1HeZfkHvFgbDaopD2oT3tRNBlgcPIbEbrhu9782Fu+/qaHj7fxhw7mCSEIVjzewi
 zeB5LO+qyyUNmIe8KiryoGjKc9/2yiig77unsxiwlgxiZwWcQaNECuzDoWsQkr91PdojhyHKgU
 uqMGXaSHl+kUce7rJy9TJNtTVbwVPXCUCwS5IjACstMYZk4+wfcHfQm+r02kNr6A7eqQfrh5Jh
 X3J1WZkYJ0hfbWajGYQXWiwgbd7fsWgDtVWxatmLTMjsHZccUkQM6z25OHUr4r/FpqSn+4/DnS
 nQc=
From:   "Schmid, Carsten" <Carsten_Schmid@mentor.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "sashal@kernel.org" <sashal@kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: AW: [PATCH Backport to stable/linux-4.14.y] make
 'user_access_begin()' do 'access_ok()'
Thread-Topic: [PATCH Backport to stable/linux-4.14.y] make
 'user_access_begin()' do 'access_ok()'
Thread-Index: AQHWCAJkVCaPiBB3fEi305LG7KYcnahj/f2V///yLoCAABfJKYAACXDf
Date:   Wed, 1 Apr 2020 10:32:42 +0000
Message-ID: <1585737161954.11435@mentor.com>
References: <8a297704c58b4b4e867efecb08214040@SVR-IES-MBX-03.mgc.mentorg.com>
 <1585733082992.99012@mentor.com>,<20200401093235.GB2055942@kroah.com>,<1585735684794.48644@mentor.com>
In-Reply-To: <1585735684794.48644@mentor.com>
Accept-Language: de-DE, en-IE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [137.202.0.90]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>>
>> Fixes CVE-2018-20669
>> Backported from v5.0-rc1
>> Patch 1/1
>
> Also, that cve was "supposed" to already be fixed in the 4.19.13 kernel
> release for some reason, and it's a drm issue, not a core access_ok()
> issue.
>
> So why is this needed for 4.14?
>
See https://access.redhat.com/security/cve/cve-2018-20669
Looks like Linus' fix was attacking this at the root cause, not only for DRM.

Also, i use https://www.linuxkernelcves.com/ as a research source,
and they claim that CVE not fixed in 4.19.
(and i'll check for the other LTS kernels as well)

>>
>> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>
> No s-o-by from you?
Ops. Will add this in a resend.

>> Want to give this work back to the community, as 4.14 is a SLTS.
>
> What is "SLTS"?
Super Long Term Supported kernel - thanks to guys like you :-)
4.14 really is that (Jan. 2024, as of https://www.kernel.org/category/releases.html)

>
> thanks,
>
> greg k-h

Thanks, and i have some other patches backported to 4.14 as CVE fixes,
which i'll propose in the next hours.

BR
Carsten
-----------------
Mentor Graphics (Deutschland) GmbH, Arnulfstraße 201, 80634 München / Germany
Registergericht München HRB 106955, Geschäftsführer: Thomas Heurung, Alexander Walter
