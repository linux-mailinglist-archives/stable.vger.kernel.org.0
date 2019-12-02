Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C80D10ED98
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 17:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbfLBQ6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 11:58:31 -0500
Received: from mga04.intel.com ([192.55.52.120]:40679 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727459AbfLBQ6b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Dec 2019 11:58:31 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Dec 2019 08:58:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,268,1571727600"; 
   d="asc'?scan'208";a="204627543"
Received: from irsmsx154.ger.corp.intel.com ([163.33.192.96])
  by orsmga008.jf.intel.com with ESMTP; 02 Dec 2019 08:58:29 -0800
Received: from irsmsx156.ger.corp.intel.com (10.108.20.68) by
 IRSMSX154.ger.corp.intel.com (163.33.192.96) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 2 Dec 2019 16:46:13 +0000
Received: from irsmsx107.ger.corp.intel.com ([169.254.10.18]) by
 IRSMSX156.ger.corp.intel.com ([169.254.3.227]) with mapi id 14.03.0439.000;
 Mon, 2 Dec 2019 16:45:55 +0000
From:   "Peres, Martin" <martin.peres@intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "Nikula, Jani" <jani.nikula@intel.com>
CC:     Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] drm/i915: Update bug URL to point at gitlab issues
Thread-Topic: [PATCH] drm/i915: Update bug URL to point at gitlab issues
Thread-Index: AQHVqQTT/PZyfOKhm0CX9le01O0Lww==
Date:   Mon, 2 Dec 2019 16:45:54 +0000
Message-ID: <56A4AB1F0E1B5D4C83D27F43C50F662E5908DF92@IRSMSX107.ger.corp.intel.com>
References: <20191125104248.1690891-1-chris@chris-wilson.co.uk>
 <878snvkojl.fsf@intel.com>
 <56A4AB1F0E1B5D4C83D27F43C50F662E5908DD0B@IRSMSX107.ger.corp.intel.com>
 <87zhgbj6xq.fsf@intel.com>
 <157529671757.27263.3691775758610826131@skylake-alporthouse-com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.249.150.87]
Content-Type: multipart/mixed;
        boundary="_002_56A4AB1F0E1B5D4C83D27F43C50F662E5908DF92IRSMSX107gercor_"
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--_002_56A4AB1F0E1B5D4C83D27F43C50F662E5908DF92IRSMSX107gercor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On 02/12/2019 16:25, Chris Wilson wrote:=0A=
> Quoting Jani Nikula (2019-12-02 11:36:01)=0A=
>> On Mon, 02 Dec 2019, "Peres, Martin" <martin.peres@intel.com> wrote:=0A=
>>> On 02/12/2019 12:30, Jani Nikula wrote:=0A=
>>>> On Mon, 25 Nov 2019, Chris Wilson <chris@chris-wilson.co.uk> wrote:=0A=
>>>>> We are moving our issue tracking over from bugs.fd.o to gitlab.fd.o, =
so=0A=
>>>>> update the user instructions accordingly.=0A=
>>>>>=0A=
>>>>> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>=0A=
>>>>> Cc: Martin Peres <martin.peres@linux.intel.com>=0A=
>>>>> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>=0A=
>>>>> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>=0A=
>>>>> Cc: Jani Nikula <jani.nikula@intel.com>=0A=
>>>>> Cc: stable@vger.kernel.org=0A=
>>>>> ---=0A=
>>>>>  drivers/gpu/drm/i915/i915_gpu_error.c | 2 +-=0A=
>>>>>  drivers/gpu/drm/i915/i915_utils.c     | 3 +--=0A=
>>>>>  drivers/gpu/drm/i915/i915_utils.h     | 2 ++=0A=
>>>>>  3 files changed, 4 insertions(+), 3 deletions(-)=0A=
>>>>>=0A=
>>>>> diff --git a/drivers/gpu/drm/i915/i915_gpu_error.c b/drivers/gpu/drm/=
i915/i915_gpu_error.c=0A=
>>>>> index 2b30a45fa25c..1cf53fd4fe66 100644=0A=
>>>>> --- a/drivers/gpu/drm/i915/i915_gpu_error.c=0A=
>>>>> +++ b/drivers/gpu/drm/i915/i915_gpu_error.c=0A=
>>>>> @@ -1817,7 +1817,7 @@ void i915_capture_error_state(struct drm_i915_p=
rivate *i915,=0A=
>>>>>     if (!xchg(&warned, true) &&=0A=
>>>>>         ktime_get_real_seconds() - DRIVER_TIMESTAMP < DAY_AS_SECONDS(=
180)) {=0A=
>>>>>             pr_info("GPU hangs can indicate a bug anywhere in the ent=
ire gfx stack, including userspace.\n");=0A=
>>>>> -           pr_info("Please file a _new_ bug report on bugs.freedeskt=
op.org against DRI -> DRM/Intel\n");=0A=
>>>>> +           pr_info("Please file a _new_ bug report on " FDO_BUG_URL =
"\n");=0A=
>>>>>             pr_info("drm/i915 developers can then reassign to the rig=
ht component if it's not a kernel issue.\n");=0A=
>>>>>             pr_info("The GPU crash dump is required to analyze GPU ha=
ngs, so please always attach it.\n");=0A=
>>>>>             pr_info("GPU crash dump saved to /sys/class/drm/card%d/er=
ror\n",=0A=
>>>>> diff --git a/drivers/gpu/drm/i915/i915_utils.c b/drivers/gpu/drm/i915=
/i915_utils.c=0A=
>>>>> index c47261ae86ea..9b68b21becf1 100644=0A=
>>>>> --- a/drivers/gpu/drm/i915/i915_utils.c=0A=
>>>>> +++ b/drivers/gpu/drm/i915/i915_utils.c=0A=
>>>>> @@ -8,8 +8,7 @@=0A=
>>>>>  #include "i915_drv.h"=0A=
>>>>>  #include "i915_utils.h"=0A=
>>>>>  =0A=
>>>>> -#define FDO_BUG_URL "https://bugs.freedesktop.org/enter_bug.cgi?prod=
uct=3DDRI"=0A=
>>>>> -#define FDO_BUG_MSG "Please file a bug at " FDO_BUG_URL " against DR=
M/Intel " \=0A=
>>>>> +#define FDO_BUG_MSG "Please file a bug at " FDO_BUG_URL \=0A=
>>>>>                 "providing the dmesg log by booting with drm.debug=3D=
0xf"=0A=
>>>>=0A=
>>>> Space between URL and "providing"?=0A=
>>>=0A=
>>> If the following comment is accepted, then we need to change this=0A=
>>> sentence to:=0A=
>>>=0A=
>>> Please file bugs according to the instruction found at FDO_BUG_URL.=0A=
>>>=0A=
>>>>=0A=
>>>>>  =0A=
>>>>>  void=0A=
>>>>> diff --git a/drivers/gpu/drm/i915/i915_utils.h b/drivers/gpu/drm/i915=
/i915_utils.h=0A=
>>>>> index 04139ba1191e..13674b016092 100644=0A=
>>>>> --- a/drivers/gpu/drm/i915/i915_utils.h=0A=
>>>>> +++ b/drivers/gpu/drm/i915/i915_utils.h=0A=
>>>>> @@ -34,6 +34,8 @@=0A=
>>>>>  struct drm_i915_private;=0A=
>>>>>  struct timer_list;=0A=
>>>>>  =0A=
>>>>> +#define FDO_BUG_URL "https://gitlab.freedesktop.org/drm/intel/issues=
/new?"=0A=
>>>>=0A=
>>>> Do we really need the question mark?=0A=
>>>=0A=
>>> We may want to point to=0A=
>>> https://gitlab.freedesktop.org/drm/intel/wikis/How-to-file-file-i915-bu=
gs,=0A=
>>> don't you think?=0A=
>>=0A=
>> Does gitlab let you set the URL, or is it always autogenerated from the=
=0A=
>> title? Need to at least fix the "file file" there. ;)=0A=
> =0A=
> Martin feel free to update the patch with the final wording and links :)=
=0A=
> -Chris=0A=
> =0A=
=0A=
Darn it, do I need to break my almost 5 year streak of not having a=0A=
single i915 patch :o?=0A=
=0A=
Well, I guess now is a good time for this, I had a patch series I wanted=0A=
to contribute anyway.=0A=
=0A=
Martin=0A=

--_002_56A4AB1F0E1B5D4C83D27F43C50F662E5908DF92IRSMSX107gercor_
Content-Type: application/pgp-keys; name="pEpkey.asc"
Content-Description: pEpkey.asc
Content-Disposition: attachment; filename="pEpkey.asc"; size=1765;
	creation-date="Mon, 02 Dec 2019 16:45:54 GMT";
	modification-date="Mon, 02 Dec 2019 16:45:54 GMT"
Content-Transfer-Encoding: base64

LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCgptUUVOQkYwc2tFc0JDQURjUTVS
cG1SeWQreU5EbkJIcmpPeURLanpsVlJVSGNiRnU4TFRVWG0rdE1OaHZxeGdMCmRCWHI5c1I2S09N
U0UxZGp2czhBZXNNdXpqa293aVcwS3I2dVFuRlRxNVZWdGFGMmwyRVdPb1ZIYlJVejV6bGYKVFBV
ajlKbU1CWjVCVGFDekRGbjA1dUU3UklKamhpcUhyd0pnUlkzZjZGazZVUjdJUVJaUWZzQXRKZXBH
NUR5ZQpkcThjcHYrM0pFMUV1eDhMR0FOTzZxd25tOEU5ZkV6VDNNVjB4QTlZVGJmeE9Hcm5jV3lp
ZkhPNzBzWnUzZm5DCngyZXI5U29KVDhZM0VzSis1L0puSUMvWHFLV3VITTNaSEc2bXhFWFM2cC9E
R3hMQzg1OWhxN28xZ1Qvem1IYjcKRERVcXRWeWNqSDkzMFRuOVRJTnYrdFVXN2hseG9oaDlZQ2Zk
QUJFQkFBRzBKbEJsY21WekxDQk5ZWEowYVc0ZwpQRzFoY25ScGJpNXdaWEpsYzBCcGJuUmxiQzVq
YjIwK2lRRlVCQk1CQ0FBK0ZpRUV5TGV5bWVpR0llcGE5VDhvCm81SHZsSnZUK05nRkFsMHNrRXND
R3dNRkNRSGhNNEFGQ3drSUJ3SUdGUW9KQ0FzQ0JCWUNBd0VDSGdFQ0Y0QUEKQ2drUW81SHZsSnZU
K05qTWdnZ0FwU2did0JDUVB0NlI4NFZENTNRYlFGbXFWMkF4YU8zWDBEZTcwRCtrdXQzaQoxck9T
SjRRalk3djNUY1hWU3VueWRaR2R5TjIwamlzSUhOcUVJNThkWVc5a1JWdDY3OFU1QkVUQTBpVGc0
clVDCjZDZWJYTzM2dlZNK2FOaEtoV0MxWHphYnlyY3pGaGdJR2pEQ1QxdXF6aUYzVlM4c3Y1Slkz
eHFqUGpQNXJoODkKMVBMd3VaR0hWci9NVFlRQXZQSXkwR0tkTTVMTFFkdjRHRytXbnE4Q0ZaU3JT
OUF0VW1oRldhV0htNWZzZ3lNTQpWQUVQYzI5cW04emFXZmJMYW9XSVBWUkJiMHZodWxoZTRBNWtG
TTAyNnYwQ2JMdHJRWjU2YlRzU2c4UUgxYk9CCkFqdkE1Z0hmcGM2NGR2T2QrRTNlMjZwcWVwRjM2
NVUvZjBlN20va2NyN2tCRFFSZExKQkxBUWdBeG5kRUVoV2gKR29ra1VZN3h1Ym8xc3J6YSs0ekxV
elFoTnBML0k0Q2VGTGUwRWN3RFlVYVpiUllOd0huRjJTTWZXTjV6S3d5VQpVSzd4UHNGYVhLTFdC
eEx1NWNHREY0UDU2b1dBWnc3U2ZxaWlhTzd3c2tablJVOW5JLzFxMzBORG5pMk5xM2d3CnVqQ0Ju
andMaWxMTTRPV0lGNGFWQW1GZHlnaEhISEZNbXp4OFhYRTZkVGg4R2o5ZU9SanV5V3NBKzFwTitQ
UFIKaWZoclp2VzFVdVZRTmZpRUJmMWkyNTRuVVhXQnhLTThHVkpnNlRaQUttWjN3RzFITTN5NjBY
UHEzVFJrKzlyaQpjeU4yTVUva29GY3VSZlFiOGQvcWtTanA1R0RDQUZMQjNMeUZKc3FGZm5qaEFP
aFk0dXoxb2tFam51TEFmc0NxCjlkUE8za3lyRVdONFJRQVJBUUFCaVFFN0JCZ0JDQUFtRmlFRXlM
ZXltZWlHSWVwYTlUOG9vNUh2bEp2VCtOZ0YKQWwwc2tFc0NHd3dGQ1FIaE00QUFDZ2tRbzVIdmxK
dlQrTmlqM3dmNGwxd0pGQnlnUVhpSlBOUjR0QUx4dG9WWgpOYm5DWDhROU9jdjU0TWdMa1lJU0Zo
dFlMZjZzSXl2RlNvazdGSEtEaWFJaW0vR2JpdVJvTitlSStMRThia2ZPCm9YR3hIazZzMHVSeTk5
UUNlSkVNaFFYZXptd2dxMHk3Nzk0OE9xNFBLTUJiVGRpdDNSL29ONDNxbldDNzdnbzUKTjN6bVdn
VHRoQXNmNWd4YXpPNGwvQ2pvZ2VWTmJLd3ZVUW1qOU1uR2dNVTUybnVyejBTTjdVUUZ2RVZGTElF
VQpjTFhsOHd6R2t1bEU1ZUs4RWg3UWp0ckp0MkNrOTZVNVdZa0R4bUVZZlU0czNqTkpzcnhYZitW
ZklFTWlheGtvCld5a1czTktJekFUU1hjOFYrTEFlT011MVJoejRBSUtXaWhzWWFJZk1HZUhITUty
QllrM2xTbzhzSS9DQgo9TEVyUQotLS0tLUVORCBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCg==

--_002_56A4AB1F0E1B5D4C83D27F43C50F662E5908DF92IRSMSX107gercor_--
