Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C08010E983
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 12:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbfLBL0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 06:26:36 -0500
Received: from mga07.intel.com ([134.134.136.100]:30121 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbfLBL0g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Dec 2019 06:26:36 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Dec 2019 03:26:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,268,1571727600"; 
   d="asc'?scan'208";a="293376337"
Received: from irsmsx101.ger.corp.intel.com ([163.33.3.153])
  by orsmga001.jf.intel.com with ESMTP; 02 Dec 2019 03:26:34 -0800
Received: from irsmsx107.ger.corp.intel.com ([169.254.10.18]) by
 IRSMSX101.ger.corp.intel.com ([169.254.1.76]) with mapi id 14.03.0439.000;
 Mon, 2 Dec 2019 11:26:33 +0000
From:   "Peres, Martin" <martin.peres@intel.com>
To:     "Nikula, Jani" <jani.nikula@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
CC:     Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] drm/i915: Update bug URL to point at gitlab issues
Thread-Topic: [PATCH] drm/i915: Update bug URL to point at gitlab issues
Thread-Index: AdWpA1lJX1ZEWB8VSsK/ITiIUehx6g==
Date:   Mon, 2 Dec 2019 11:26:33 +0000
Message-ID: <56A4AB1F0E1B5D4C83D27F43C50F662E5908DD0B@IRSMSX107.ger.corp.intel.com>
References: <20191125104248.1690891-1-chris@chris-wilson.co.uk>
 <878snvkojl.fsf@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.249.150.50]
Content-Type: multipart/mixed;
        boundary="_002_56A4AB1F0E1B5D4C83D27F43C50F662E5908DD0BIRSMSX107gercor_"
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--_002_56A4AB1F0E1B5D4C83D27F43C50F662E5908DD0BIRSMSX107gercor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On 02/12/2019 12:30, Jani Nikula wrote:=0A=
> On Mon, 25 Nov 2019, Chris Wilson <chris@chris-wilson.co.uk> wrote:=0A=
>> We are moving our issue tracking over from bugs.fd.o to gitlab.fd.o, so=
=0A=
>> update the user instructions accordingly.=0A=
>>=0A=
>> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>=0A=
>> Cc: Martin Peres <martin.peres@linux.intel.com>=0A=
>> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>=0A=
>> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>=0A=
>> Cc: Jani Nikula <jani.nikula@intel.com>=0A=
>> Cc: stable@vger.kernel.org=0A=
>> ---=0A=
>>  drivers/gpu/drm/i915/i915_gpu_error.c | 2 +-=0A=
>>  drivers/gpu/drm/i915/i915_utils.c     | 3 +--=0A=
>>  drivers/gpu/drm/i915/i915_utils.h     | 2 ++=0A=
>>  3 files changed, 4 insertions(+), 3 deletions(-)=0A=
>>=0A=
>> diff --git a/drivers/gpu/drm/i915/i915_gpu_error.c b/drivers/gpu/drm/i91=
5/i915_gpu_error.c=0A=
>> index 2b30a45fa25c..1cf53fd4fe66 100644=0A=
>> --- a/drivers/gpu/drm/i915/i915_gpu_error.c=0A=
>> +++ b/drivers/gpu/drm/i915/i915_gpu_error.c=0A=
>> @@ -1817,7 +1817,7 @@ void i915_capture_error_state(struct drm_i915_priv=
ate *i915,=0A=
>>  	if (!xchg(&warned, true) &&=0A=
>>  	    ktime_get_real_seconds() - DRIVER_TIMESTAMP < DAY_AS_SECONDS(180))=
 {=0A=
>>  		pr_info("GPU hangs can indicate a bug anywhere in the entire gfx stac=
k, including userspace.\n");=0A=
>> -		pr_info("Please file a _new_ bug report on bugs.freedesktop.org again=
st DRI -> DRM/Intel\n");=0A=
>> +		pr_info("Please file a _new_ bug report on " FDO_BUG_URL "\n");=0A=
>>  		pr_info("drm/i915 developers can then reassign to the right component=
 if it's not a kernel issue.\n");=0A=
>>  		pr_info("The GPU crash dump is required to analyze GPU hangs, so plea=
se always attach it.\n");=0A=
>>  		pr_info("GPU crash dump saved to /sys/class/drm/card%d/error\n",=0A=
>> diff --git a/drivers/gpu/drm/i915/i915_utils.c b/drivers/gpu/drm/i915/i9=
15_utils.c=0A=
>> index c47261ae86ea..9b68b21becf1 100644=0A=
>> --- a/drivers/gpu/drm/i915/i915_utils.c=0A=
>> +++ b/drivers/gpu/drm/i915/i915_utils.c=0A=
>> @@ -8,8 +8,7 @@=0A=
>>  #include "i915_drv.h"=0A=
>>  #include "i915_utils.h"=0A=
>>  =0A=
>> -#define FDO_BUG_URL "https://bugs.freedesktop.org/enter_bug.cgi?product=
=3DDRI"=0A=
>> -#define FDO_BUG_MSG "Please file a bug at " FDO_BUG_URL " against DRM/I=
ntel " \=0A=
>> +#define FDO_BUG_MSG "Please file a bug at " FDO_BUG_URL \=0A=
>>  		    "providing the dmesg log by booting with drm.debug=3D0xf"=0A=
> =0A=
> Space between URL and "providing"?=0A=
=0A=
If the following comment is accepted, then we need to change this=0A=
sentence to:=0A=
=0A=
Please file bugs according to the instruction found at FDO_BUG_URL.=0A=
=0A=
> =0A=
>>  =0A=
>>  void=0A=
>> diff --git a/drivers/gpu/drm/i915/i915_utils.h b/drivers/gpu/drm/i915/i9=
15_utils.h=0A=
>> index 04139ba1191e..13674b016092 100644=0A=
>> --- a/drivers/gpu/drm/i915/i915_utils.h=0A=
>> +++ b/drivers/gpu/drm/i915/i915_utils.h=0A=
>> @@ -34,6 +34,8 @@=0A=
>>  struct drm_i915_private;=0A=
>>  struct timer_list;=0A=
>>  =0A=
>> +#define FDO_BUG_URL "https://gitlab.freedesktop.org/drm/intel/issues/ne=
w?"=0A=
> =0A=
> Do we really need the question mark?=0A=
=0A=
We may want to point to=0A=
https://gitlab.freedesktop.org/drm/intel/wikis/How-to-file-file-i915-bugs,=
=0A=
don't you think?=0A=
=0A=
Martin=0A=
=0A=
> =0A=
> BR,=0A=
> Jani.=0A=
> =0A=
>> +=0A=
>>  #undef WARN_ON=0A=
>>  /* Many gcc seem to no see through this and fall over :( */=0A=
>>  #if 0=0A=
> =0A=
=0A=

--_002_56A4AB1F0E1B5D4C83D27F43C50F662E5908DD0BIRSMSX107gercor_
Content-Type: application/pgp-keys; name="pEpkey.asc"
Content-Description: pEpkey.asc
Content-Disposition: attachment; filename="pEpkey.asc"; size=1774;
	creation-date="Mon, 02 Dec 2019 11:26:32 GMT";
	modification-date="Mon, 02 Dec 2019 11:26:32 GMT"
Content-Transfer-Encoding: base64

LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCgptUUVOQkYzazA1Z0JDQUN5WmhP
WGExNGJUY3lUUWtjMVV5R2ZjNGx4ckhQREw1YXVPbkM3cUVIWkw1b3ZWd3NDCmF1ZlFaOVFKVWwx
NHh1OCt4dUl6UGoyWXhEbjFBeVJFN0RzSXNxNjVIaDlRa2YxQytFNmtHeHBDS2VXeFpEalIKS0xE
a2pQWmdRTTdOeHNFWkRkemNaTlFLUEt3OXBXUUovRCtrSUlyNDJYaERhbktyQ1pHV3Vxc3VwVGI4
YmM2agp3ZnBxVzV2eUp2WnVMSHcrTURhRVhoZ1Z0SlVWYVdSWENXbXFZQU1YWFlMMGh5NHVjRDZz
UWl3U2psK3JUU2NIClhqSHdhWURWWTI5bVFlR3lWMDMyeXBFWFQzWG1DVTJVT0hhNENNaktLR3ZK
MjRBU2Q5SFkyWHo4cmNyR1pTbGsKRkhMTGRwNUNET2wrRFU2Vjc5SWs5a3pPMFVxK0hXWDRtc2Z4
QUJFQkFBRzBLMDFoY25ScGJpQlFaWEpsY3lBOApiV0Z5ZEdsdUxuQmxjbVZ6UUd4cGJuVjRMbWx1
ZEdWc0xtTnZiVDZKQVZRRUV3RUlBRDRXSVFSTjlzUS9iN0dPClhRdkh5WUVDditaL002VXplUVVD
WGVUVG1RSWJBd1VKQWVFemdBVUxDUWdIQWdZVkNna0lDd0lFRmdJREFRSWUKQVFJWGdBQUtDUkFD
ditaL002VXplUmJ3Qi85ZHhZaG01WU14eGlSa2tZRVBrOE9DUGZjOGJwazF6RFc5Nkc0MgpLYVoz
RlRPRGNSMktjelg1ZVRMRFYwdklNRndqMmw0UXAvRFpzbVlsNzlKNDNhbHg1RHRIQUZJMlJHSis2
dXJhClFZMkovVXUvUWt5eEdrMTRpQUFzYytaalJSdWllQ1h0Wkc2THRMYmdsTUZCWUd4dzlWVEow
L0xhNHJjUVk3UksKOW1KM1QwWUxKMkJNNlVha3lUWEdzbnN0aWtOa2wzU0JKVDBJc1B1bVdGL240
a25penZQcG5BTGNQWGwwS3VtUwpuZDZ1b2dPT3VrQ0t4Z0RUWm1qRG9meDVvN1pveDI5blNkdjR3
aVJMOHVBeDRrY0pPOUxPOFhBN0lITzd6SXRTCmpXbWRXRmN4QTVicFRkRWR0TThIQWlCQkFaNU44
WXVraENuejltT0FFOXZLOXZydHVRRU5CRjNrMDVrQkNBREwKR3JGN1NBblB5NVo2R2ZlelZDclFm
dUlHSmhPemxuY0c2aFdHYU05YzlDVEtxSGZDNHROV1VFeHJmam5YNjBtRgpJbUx2aHhlRlZDOWJv
QS9jNGFVTmhEYy9NOUtqc08ycWRyd2d4QXl3bnIraVJqbzNORUJWQkF3T2NldWRRM0xPClZmZW5k
b296d3lqd3ZZRFV2QzNUcWtjajBsNmE2R3JqZTZWMVVTQ3RIL0ZlR2NONG9EMnZPOW1yWFlQb2hr
V2cKU3B2QUpPSEs5bk5nMUtaTjcvcDlXNUZMMlZZN2pIbHErd1gxZDBTRytRNlhjVHNEQUEyOStO
YmM1Qk0vcTJJTAphV1Fva0I0bzBaRjNsakZiN2RYZDNRZEpNWDdvNXRURzFMUi9TalZmbkZGckMw
K1IrZGhlRUVldGxVckRMRmF0CnhnRTdvREVPLzA4c2g5eHJPdzdMQUJFQkFBR0pBVHdFR0FFSUFD
WVdJUVJOOXNRL2I3R09YUXZIeVlFQ3YrWi8KTTZVemVRVUNYZVRUbVFJYkRBVUpBZUV6Z0FBS0NS
QUN2K1ovTTZVemVTMVRCLzlNbTFYTUhpbWtFbW15ZXNiMQpxdHFUY2htV2Q1NWhiRkIxMDRSbUx5
c0VrSU43Q3IweVNEZjBZRWxxd2QvSDlGWWVLUTVEWWJWWS9CclhjeGYzCmNKVDJBZ01Zdk54bHZ5
NHluR1F4Yy9YbXRzMGZVSno5cmRVVmZxZlFKbDlHZkR1U3dpQnhmb3BlN21aR2NIZWcKNzBaQTg3
Q0xJQ0FVbi9uRFpSekZuUHNhdUxJSU9sMGhxVWtJUml3WVp0WW9WZnNoVGhTNzNEcXNGS2U0Y25r
eApZcGVCRXNsYUduZnRMUC9uWDl6dkZ4SXJYUXBPdHJ2eWdkWklhMVMrZXhYM2NXMHNPYm02Zjk0
T3Q1Mjl3V3pTCnhJRjBvRnZPY3NlZ2ErL3FPK1hSNHNjbUJ1K3NUVU5FQnA1NWYyc0ptOWllVlU5
SXUwM2JYVnBMZGV3dTNtMEIKTTVtaAo9YzJPTwotLS0tLUVORCBQR1AgUFVCTElDIEtFWSBCTE9D
Sy0tLS0tCg==

--_002_56A4AB1F0E1B5D4C83D27F43C50F662E5908DD0BIRSMSX107gercor_--
