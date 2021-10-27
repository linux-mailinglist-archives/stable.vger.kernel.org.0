Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E4643CEDD
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 18:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237816AbhJ0Qpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 12:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237657AbhJ0Qps (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 12:45:48 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FF4C061570;
        Wed, 27 Oct 2021 09:43:22 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id i9so2522370qki.3;
        Wed, 27 Oct 2021 09:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:user-agent:in-reply-to:references
         :message-id:mime-version:content-transfer-encoding;
        bh=fVvSjlYcUQ/4twrO1k18VitO42Q8EP1MJyf6lkiHJFs=;
        b=QWKcyfDGhuNQScMc0UiAfBOi8yqDwjy/FTtKRAb+Y+aQWxdTQyrXJNFQclo2Gapg0m
         j/C3LPsdw+kjtjsuTYllMavMWohcLMZTrzMDWZuTDy+6v69ah3AzoS6TO53e4Z6stLLk
         26cQCHAQKHFT+D22tzArZn11fFP7MMNPuyG0TN9OnP7XUbdfzgje0qJFOG1kUkONZV4e
         yx117tKdkv0ywTVpdsIDEpDYGXU7kkQzrhetSyI0NuWAgvWpkpgHDlCVo/0lDIMl23wP
         xP96TDQx+RQJBPI/Nmjo4Ql4Y3RWb1SEsYhNJhgWGkol/hr61VPaocIzNo4jYneY0Yfz
         BMbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:user-agent:in-reply-to
         :references:message-id:mime-version:content-transfer-encoding;
        bh=fVvSjlYcUQ/4twrO1k18VitO42Q8EP1MJyf6lkiHJFs=;
        b=3ah568/znyyN+lrULSJzIWPH38w/XS7zhOkTYk4xYKLUsDHE4+WWnJNAgekwNz/xie
         6z3rNMF6wV/oG2GYMxU4Jomn1dFuWjck2M4DWQN0kO1NrPfyG8Gm8KyVGDF+8ug3wVIr
         7Fwu9eDknQ0QTofoVZdQbaJoTZapPIRj5kdyvNyIW9RfTggTXza0XuRujayI0VkHP+se
         01y35HRasd8oVQR3aedxRhjGi2lhiiL4FVdbJiOYeZ7PxwF8oX1VnqszMacTy5aXGjG5
         7B7tSDrEAfU8ABM7RyjfchPxrRCnY7BVo5Zi3aoNnbTGtNnPJ6oeGLrdyuU0qFdLA9cJ
         lMYA==
X-Gm-Message-State: AOAM5313LSL+bm3ZhQgRPUh+FCWSCefNQFFveVFVYd2iA8uRmIP7Lvm/
        wHG8uMNqE+6Thk1pNp3And4=
X-Google-Smtp-Source: ABdhPJxEKt+P1BxPsFiuldPeaaMJT3FBZl1LO/h19LWgtG/tg+pjzGEF1XM1hjFhOkCGspKHxyKIpg==
X-Received: by 2002:a37:606:: with SMTP id 6mr6837186qkg.18.1635353002042;
        Wed, 27 Oct 2021 09:43:22 -0700 (PDT)
Received: from [127.0.0.1] ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id bi26sm295887qkb.102.2021.10.27.09.43.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 09:43:21 -0700 (PDT)
Date:   Wed, 27 Oct 2021 13:43:01 -0300
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
To:     Song Liu <songliubraving@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC:     LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, stable <stable@vger.kernel.org>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_perf-script=3A_check_sess?= =?US-ASCII?Q?ion-=3Eheader=2Eenv=2Earch_before_using_it?=
User-Agent: K-9 Mail for Android
In-Reply-To: <806C5000-3A49-42B0-B0AE-7ED001CB11EE@fb.com>
References: <20211004053238.514936-1-songliubraving@fb.com> <YXlIhneZVyihywLt@kernel.org> <806C5000-3A49-42B0-B0AE-7ED001CB11EE@fb.com>
Message-ID: <BDFE00C7-4C10-4916-ADEA-9C2B5263E797@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On October 27, 2021 1:41:50 PM GMT-03:00, Song Liu <songliubraving@fb=2Eco=
m> wrote:
>
>
>> On Oct 27, 2021, at 5:39 AM, Arnaldo Carvalho de Melo <acme@kernel=2Eor=
g> wrote:
>>=20
>> Em Sun, Oct 03, 2021 at 10:32:38PM -0700, Song Liu escreveu:
>>> When perf=2Edata is not written cleanly, we would like to process exis=
ting
>>> data as much as possible (please see f_header=2Edata=2Esize =3D=3D 0 c=
ondition
>>> in perf_session__read_header)=2E However, perf=2Edata with partial dat=
a may
>>> crash perf=2E Specifically, we see crash in perf-script for NULL
>>> session->header=2Eenv=2Earch=2E
>>>=20
>>> Fix this by checking session->header=2Eenv=2Earch before using it to d=
etermine
>>> native_arch=2E Also split the if condition so it is easier to read=2E
>>>=20
>>> Cc: stable@vger=2Ekernel=2Eorg
>>> Signed-off-by: Song Liu <songliubraving@fb=2Ecom>
>>> ---
>>> tools/perf/builtin-script=2Ec | 13 +++++++++----
>>> 1 file changed, 9 insertions(+), 4 deletions(-)
>>>=20
>>> diff --git a/tools/perf/builtin-script=2Ec b/tools/perf/builtin-script=
=2Ec
>>> index 6211d0b84b7a6=2E=2E7821f6740ac1d 100644
>>> --- a/tools/perf/builtin-script=2Ec
>>> +++ b/tools/perf/builtin-script=2Ec
>>> @@ -4039,12 +4039,17 @@ int cmd_script(int argc, const char **argv)
>>> 		goto out_delete;
>>>=20
>>> 	uname(&uts);
>>> -	if (data=2Eis_pipe ||  /* assume pipe_mode indicates native_arch */
>>> -	    !strcmp(uts=2Emachine, session->header=2Eenv=2Earch) ||
>>> -	    (!strcmp(uts=2Emachine, "x86_64") &&
>>> -	     !strcmp(session->header=2Eenv=2Earch, "i386")))
>>> +	if (data=2Eis_pipe)  /* assume pipe_mode indicates native_arch */
>>> 		native_arch =3D true;
>>>=20
>>> +	if (session->header=2Eenv=2Earch) {
>>=20
>> Shouldn't the above be:
>>=20
>> 	else if (session->header=2Eenv=2Earch) {
>>=20
>> ?
>
>Yes! That's better=2E=20
>
>Do you want me to send v2 with the change?=20


No need, it's simple enough, I'll do it myself,

- Arnaldo
>
>Thanks,
>Song
>
>>=20
>>> +		if (!strcmp(uts=2Emachine, session->header=2Eenv=2Earch))
>>> +			native_arch =3D true;
>>> +		else if (!strcmp(uts=2Emachine, "x86_64") &&
>>> +			 !strcmp(session->header=2Eenv=2Earch, "i386"))
>>> +			native_arch =3D true;
>>> +	}
>>> +
>>> 	script=2Esession =3D session;
>>> 	script__setup_sample_type(&script);
>>>=20
>>> --=20
>>> 2=2E30=2E2
>>=20
>> --=20
>>=20
>> - Arnaldo
>
