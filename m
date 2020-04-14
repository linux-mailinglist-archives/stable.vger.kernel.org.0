Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9433A1A70A4
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 03:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgDNBtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 21:49:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40297 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728247AbgDNBtI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 21:49:08 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200414014904epoutp0153a3887ad773fbb8c9e706e251ee968b~FjIScLhoZ0665306653epoutp01G
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 01:49:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200414014904epoutp0153a3887ad773fbb8c9e706e251ee968b~FjIScLhoZ0665306653epoutp01G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1586828944;
        bh=H0dcMp3IVJ0pRvu6+aBqLGf9F2h8QIQA3B0K/eOxXO4=;
        h=From:To:Cc:Subject:Date:References:From;
        b=eVzry52cxcG3nZmmepjB9xFxgAvSUaz4yScCzR1jHOm04dtyicytvDY7ucj8SD9xl
         BERVR7es+QZ2HAxbn7iAG37Jq609MG1unoGjZrVBhUpC3YJCR7k/d+QtrNewq/fR3l
         eqHD7y1vbNpKBTfzK2SYkLrJhVsxEWr7otraiJSI=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200414014904epcas2p22e045e1aaa6b6dd5017e51caa5529208~FjIR_ELOI0174701747epcas2p2l;
        Tue, 14 Apr 2020 01:49:04 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.186]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 491T1B71tLzMqYkh; Tue, 14 Apr
        2020 01:49:02 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        6B.42.04704.B86159E5; Tue, 14 Apr 2020 10:48:59 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200414014858epcas2p3e9028454a601cd9852ba6444f183d8c9~FjIMYJlnZ1798117981epcas2p3X;
        Tue, 14 Apr 2020 01:48:58 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200414014858epsmtrp21df876255c1b14dce4efedf9f6ab2123~FjIMXUI2L2773527735epsmtrp2k;
        Tue, 14 Apr 2020 01:48:58 +0000 (GMT)
X-AuditID: b6c32a46-811ff70000001260-d2-5e95168b1093
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7D.5A.04024.A86159E5; Tue, 14 Apr 2020 10:48:58 +0900 (KST)
Received: from KORDO025540 (unknown [12.36.182.130]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200414014858epsmtip171bf3472f072c1fa600e2196deca8008~FjIMPH1LW2172921729epsmtip1-;
        Tue, 14 Apr 2020 01:48:58 +0000 (GMT)
From:   "Gyeongtaek Lee" <gt82.lee@samsung.com>
To:     <stable@vger.kernel.org>
Cc:     <broonie@kernel.org>, <tiwai@suse.com>, <tkjung@samsung.com>,
        <hmseo@samsung.com>, <tkjung@samsung.com>, <kimty@samsung.com>
Subject: [PATCH 0/4] Fixes for ASoC DPCM and topology
Date:   Tue, 14 Apr 2020 10:48:57 +0900
Message-ID: <000401d611fe$dd1589f0$97409dd0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ks_c_5601-1987"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AdYR/qGnUB2/ITIZSPm3Wdblo8sHgw==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTcRTH++1ud9NcXKfZYYStKxkqrm25eTXtQQ8GGglFUZh21dtm7cXu
        Zuk/TUXbXGiFj/KVhgjaS2WJgSN8QGgU/aGUEUVhYBb2WKRRRnfdBfvvc37n+/2dczhHgsna
        cLmk1OJg7BbaROKRwuGJJG2qN66pQPXpawLV9HYep64Ne4XUrVmfgOoafIeogeU7iJqsbBTs
        xvVD/R5cX+/rR/p7vlmhPjAUnyc8YcoyMnQJY1cwlmJrSanFkE3mHC7cW6jVqdSp6gwqnVRY
        aDOTTe7LzUs9UGriipOKMtrk5J7yaJYlt+3MsludDkZhtLKObJKxlZhsarVNydJm1mkxKIut
        5ky1SqXRcspTJuPcWACzLaw9P9rWIHKhscg6FCEBIg0q+1bxIMuIEQQzzdl1KJLjbwi+e6sQ
        H/zggm9j+H9Hx8sGjE/4EdS/6RLzwQcEnbdbUFCFE6nw/fUrLMixxEZoqfELgowRVQiq3blB
        jiG08K7ZIw6ykNgCLxa6RUGWEhnQMPAR8RwNU9fnhbxXAz23boT+SYHe7o8Y35ECfr7vFfG1
        lDDb/QDjNbHQ5qn91ykQozi43Cshwz7wzywJeI6BxUc+Mc9yCCz5cd5QjWDpye9QohGBxyvj
        eTv4OqY5s4TjBJh8GWpuHbgnVsX8sxTctSE1CYPTf0JqgM6BkEIPX/rQZbS5NWzI1rAhW8OG
        bA0bpgsJ+1EcY2PNBobV2DThyx5C/w4z+cAI6nmaO44ICSKjpJcPNRbIRHQZW24eRyDByFjp
        /LkrBTJpCV1ewdithXaniWHHkZZbwhVMvr7Yyp25xVGo1mp0OlWGltLqNBS5QTq0di5fRhho
        B3OWYWyM/b9PIImQu9CUc3C/P970rFx8dyDmaKShL+2Y82H8vbkjSR1u9em0i8tlK0VVRmfi
        yqKnybWn3Vvh8uRfakz4XBQT97w3c8fj4zVX9VsFE5Cec+75rpQz0cpf5jMLF/xLp2dEK8qA
        MmkxEUXULN88GF3dvkmk0t1v8Qaaz5rfR0nWnEzKyMqUk0LWSKuTMTtL/wVxq0DergMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWy7bCSnG6X2NQ4g6Y9IhZTHz5hs5ixrZvF
        YvXVLUwWCzY+YrTY8H0to8WRxilMDmwem1Z1snn0bVnF6LF+y1UWj8+b5AJYorhsUlJzMstS
        i/TtErgytn+7zFzwkbPi0yr7Bsav7F2MnBwSAiYSc2/1M3cxcnEICexmlDjV8pwZIiEh8WH+
        GagiYYn7LUdYIYqeM0rMnDYZrIhNQFfiy707YLaIgIzE9Na9TCA2s0AXo8T6U2ogtrCAqcSj
        aZ1gg1gEVCVuvFjICmLzClhK9G94zQhhC0qcnPmEBaLXRKLxcDeUrS2xbOFrqIMUJH4+XcYK
        sUtP4urCncwQNSISszvbmCcwCs5CMmoWklGzkIyahaRlASPLKkbJ1ILi3PTcYsMCw7zUcr3i
        xNzi0rx0veT83E2M4EjQ0tzBeHlJ/CFGAQ5GJR7eCf5T4oRYE8uKK3MPMUpwMCuJ8D4pnxgn
        xJuSWFmVWpQfX1Sak1p8iFGag0VJnPdp3rFIIYH0xJLU7NTUgtQimCwTB6dUA6NVWeiTubO0
        p/Yc+f/6zfYnh16eeWNnZ/DP0FFpyZt1OUVzK5i4c76d3cG6UFRMZN9K0z/fzs2o+Fi1hqXn
        /eoe9S/nWV9/qQoObvc93N58oTBCLqez3/PpoqX/WzeLHpoQYlkbtsMsLr8h/Gpi0+SlRU+e
        nf71/ol6dqnMqq2n/4oddo38t6hYiaU4I9FQi7moOBEAI9f79YACAAA=
X-CMS-MailID: 20200414014858epcas2p3e9028454a601cd9852ba6444f183d8c9
X-Msg-Generator: CA
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200414014858epcas2p3e9028454a601cd9852ba6444f183d8c9
References: <CGME20200414014858epcas2p3e9028454a601cd9852ba6444f183d8c9@epcas2p3.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I'd like to request cherry-picking some fixes for ALSA SoC to stable branch=
.
Those patches are fix or add couple of functions which are essential when A=
LSA topology and Compress offload is used with Dynamic
PCM.
All fixes are tested on 4.19 and 5.4.

1. Fix overflow of register mask when shift value is set to 32.
2. Default value setting for virtual kcontrol
3. Error on offload playback start or stop after pause
4. Prefix missing when a kcontrol is created with ASoC component with name =
prefix.

Commit ID:
  0ab070917afdc93670c2d0ea02ab6defb6246a7c
  3bbbb7728fc853d71dbce4073fef9f281fbfb4dd
  21fca8bdbb64df1297e8c65a746c4c9f4a689751
  abca9e4a04fbe9c6df4d48ca7517e1611812af25

Kernel version wish it to be applied:
  5.4

Subject:
=C0=CC=B0=E6=C5=C3=20(4):=0D=0A=20=20ASoC:=20fix=20regwmask=0D=0A=20=20ASoC=
:=20dapm:=20connect=20virtual=20mux=20with=20default=20value=0D=0A=20=20ASo=
C:=20dpcm:=20allow=20start=20or=20stop=20during=20pause=20for=20backend=0D=
=0A=20=20ASoC:=20topology:=20use=20name_prefix=20for=20new=20kcontrol=0D=0A=
=0D=0A=20sound/soc/soc-dapm.c=20=20=20=20=20=7C=208=20+++++++-=0D=0A=20soun=
d/soc/soc-ops.c=20=20=20=20=20=20=7C=204=20++--=0D=0A=20sound/soc/soc-pcm.c=
=20=20=20=20=20=20=7C=206=20++++--=0D=0A=20sound/soc/soc-topology.c=20=7C=
=202=20+-=0D=0A=204=20files=20changed,=2014=20insertions(+),=206=20deletion=
s(-)=0D=0A=0D=0A=0D=0Abase-commit:=20bc844d58f697dff3ded4b410094ee89f5cedc0=
4c=0D=0A--=20=0D=0A2.21.0=0D=0A=0D=0A
