Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44CBC45ACF5
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 21:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhKWUEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 15:04:00 -0500
Received: from meesny.iki.fi ([195.140.195.201]:47330 "EHLO meesny.iki.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239128AbhKWUD7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 15:03:59 -0500
Received: from [172.16.24.131] (73-55.dynamonet.fi [85.134.55.73])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: tmb@iki.fi)
        by meesny.iki.fi (Postfix) with ESMTPSA id 74CBF202B7;
        Tue, 23 Nov 2021 22:00:49 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
        t=1637697649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J+RXdYW3xCoqWF3NRZa/mlI03JmcrTDV1YQOcG/1yxQ=;
        b=QVOuBuCfGkUAncpsZ10hi0IteI/bYTh9UeGul3OZ7c3iH1YqYkQ0iJVO7PtnI/QlTlVlut
        1hPK2oRrhdkLUidqlMV50fATdpiNbm7XYZmnKvQrdvtwCvIU37GsIXO1iEd29gGTOaTsV+
        Kc8mVFI/EX80UXRaxF8y6sXmNnDIDqM=
Message-ID: <d0eca47c-73f8-3d7f-3eb8-4ee7722022f8@iki.fi>
Date:   Tue, 23 Nov 2021 22:00:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: FAILED: patch "[PATCH] signal: Don't always set SA_IMMUTABLE for
 forced signals" failed to apply to 5.15-stable tree
Content-Language: en-US
To:     ebiederm@xmission.com, Greg KH <gregkh@linuxfoundation.org>
Cc:     Thomas Backlund <tmb@iki.fi>, keescook@chromium.org,
        khuey@kylehuey.com, me@kylehuey.com, oliver.sang@intel.com,
        torvalds@linux-foundation.org, stable@vger.kernel.org
References: <163758427225348@kroah.com>
 <c83d6b54-d02f-c23b-d1cc-76c1993031d5@iki.fi> <YZ0vAK6QJJFP3jY5@kroah.com>
 <aGPtF092eTtTol3Vfasn4-kVySgX_vBRkK7e4jX97omisSwgyJR7vHltUrS1bwNE9pYuB2N2nSas1HWLQxUBNg==@protonmail.internalid>
 <877dcyllom.fsf@email.froward.int.ebiederm.org>
From:   Thomas Backlund <tmb@iki.fi>
In-Reply-To: <877dcyllom.fsf@email.froward.int.ebiederm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=tmb@iki.fi smtp.mailfrom=tmb@iki.fi
ARC-Seal: i=1; s=meesny; d=iki.fi; t=1637697649; a=rsa-sha256; cv=none;
        b=idSQ/K8V/AgG7zhmOmgtEW6BEe19OkxukM0UqCsZ8IQnTbqgvCvlYyDcrabCCBSLvMFwIN
        Qhygy3mjC5MxWw+Ulh4Kcxl5n9jLWa7+smFsYzSE6Z3ISzNDWERhkbaMOCxoyaujAbkWjX
        6/nu1UeQkHDL7yaGiVCHJ1/v3ZXSOZY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
        s=meesny; t=1637697649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J+RXdYW3xCoqWF3NRZa/mlI03JmcrTDV1YQOcG/1yxQ=;
        b=RJwWuDYvHPqvdmu7xoenKoE1kvjBTAougq7DkJ4FZM44STals0COQYxqXORvDBN5Q7rUh0
        FnuWFwEGZxTBQ6F7/8fEJ9+5aywrgLVrAB2el+QBJwQoUX0cBUN+D8flwAYwGStKRyXAzH
        XamxBDZ34XJOTQdfobf4w44fXgGl1vA=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Den 2021-11-23 kl. 21:24, skrev ebiederm@xmission.com:
> Greg KH <gregkh@linuxfoundation.org> writes:
>
>> On Tue, Nov 23, 2021 at 07:29:43PM +0200, Thomas Backlund wrote:
>>> Den 2021-11-22 kl. 14:31, skrev gregkh@linuxfoundation.org:
>>>> The patch below does not apply to the 5.15-stable tree.
>>>> If someone wants it applied there, or to any other stable or longterm
>>>> tree, then please email the backport, including the original git commit
>>>> id to <stable@vger.kernel.org>.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>
>>> It will apply if you add this one first:
>>>
>>>  From 26d5badbccddcc063dc5174a2baffd13a23322aa Mon Sep 17 00:00:00 2001
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Date: Wed, 20 Oct 2021 12:43:59 -0500
>>> Subject: [PATCH] signal: Implement force_fatal_sig
>>>
>>>
>>>
>>>
>>> and if the other patch for signal that has similar description should land
>>> in 5.15:
>>>
>>>  From fcb116bc43c8c37c052530ead79872f8b2615711 Mon Sep 17 00:00:00 2001
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Date: Thu, 18 Nov 2021 14:23:21 -0600
>>> Subject: [PATCH] signal: Replace force_fatal_sig with force_exit_sig when in
>>> doubt
>>>
>>>
>>>
>>> then the list is looks something like:
>>>
>>>
>>>  From 941edc5bf174b67f94db19817cbeab0a93e0c32a Mon Sep 17 00:00:00 2001
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Date: Wed, 20 Oct 2021 12:44:00 -0500
>>> Subject: [PATCH] exit/syscall_user_dispatch: Send ordinary signals on
>>> failure
>>>
>>>  From 83a1f27ad773b1d8f0460d3a676114c7651918cc Mon Sep 17 00:00:00 2001
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Date: Wed, 20 Oct 2021 12:43:53 -0500
>>> Subject: [PATCH] signal/powerpc: On swapcontext failure force SIGSEGV
>>>
>>>  From 9bc508cf0791c8e5a37696de1a046d746fcbd9d8 Mon Sep 17 00:00:00 2001
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Date: Wed, 20 Oct 2021 12:43:57 -0500
>>> Subject: [PATCH] signal/s390: Use force_sigsegv in default_trap_handler
>>>
>>>  From c317d306d55079525c9610267fdaf3a8a6d2f08b Mon Sep 17 00:00:00 2001
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Date: Wed, 20 Oct 2021 12:44:01 -0500
>>> Subject: [PATCH] signal/sparc32: Exit with a fatal signal when
>>>   try_to_clear_window_buffer fails
>>>
>>>  From 086ec444f86660e103de8945d0dcae9b67132ac9 Mon Sep 17 00:00:00 2001
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Date: Wed, 20 Oct 2021 12:44:02 -0500
>>> Subject: [PATCH] signal/sparc32: In setup_rt_frame and setup_fram use
>>>   force_fatal_sig
>>>
>>>  From 1fbd60df8a852d9c55de8cd3621899cf4c72a5b7 Mon Sep 17 00:00:00 2001
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Date: Wed, 20 Oct 2021 12:43:56 -0500
>>> Subject: [PATCH] signal/vm86_32: Properly send SIGSEGV when the vm86 state
>>> cannot be saved.
>>>
>>>  From 695dd0d634df8903e5ead8aa08d326f63b23368a Mon Sep 17 00:00:00 2001
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Date: Wed, 20 Oct 2021 12:44:03 -0500
>>> Subject: [PATCH] signal/x86: In emulate_vsyscall force a signal instead of
>>> calling do_exit
>>>
>>>  From 26d5badbccddcc063dc5174a2baffd13a23322aa Mon Sep 17 00:00:00 2001
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Date: Wed, 20 Oct 2021 12:43:59 -0500
>>> Subject: [PATCH] signal: Implement force_fatal_sig
>>>
>>>  From e21294a7aaae32c5d7154b187113a04db5852e37 Mon Sep 17 00:00:00 2001
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Date: Mon, 25 Oct 2021 10:50:57 -0500
>>> Subject: [PATCH] signal: Replace force_sigsegv(SIGSEGV) with
>>>   force_fatal_sig(SIGSEGV)
>>>
>>>  From e349d945fac76bddc78ae1cb92a0145b427a87ce Mon Sep 17 00:00:00 2001
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Date: Thu, 18 Nov 2021 11:11:13 -0600
>>> Subject: [PATCH] signal: Don't always set SA_IMMUTABLE for forced signals
>>>
>>>  From fcb116bc43c8c37c052530ead79872f8b2615711 Mon Sep 17 00:00:00 2001
>>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>>> Date: Thu, 18 Nov 2021 14:23:21 -0600
>>> Subject: [PATCH] signal: Replace force_fatal_sig with force_exit_sig when in
>>> doubt
>>>
>>>
>>>
>>> Applying them in listed order on top of 5.14.4 and builds/runs on i586,
>>> x86_64, armv7hl, aarch64
>> That series list is crazy, let me go try it and see what blows up! :)
> Maybe I am wrong but I think "Don't always set SA_IMMUTABLE for forced
> signals" will apply if you drop the hunk modifying force_fatal_sig.
> Then you don't need to backport all of the cleanups just the fix.
>
> I will take a quick look and verify that.


that's why i wrote: "if the other patch for signal that has similar 
description should land"

(meaning "signal: Replace force_fatal_sig with force_exit_sig when in 
doubt")

as thats the one needing the whole patch series...


since going by patch descriptions for:

"signal: Don't always set SA_IMMUTABLE for forced signals"

"signal: Replace force_fatal_sig with force_exit_sig when in doubt"


both has the info:

"Unfortunately this broke debuggers[1][2] which reasonably expect
to be able to trap synchronous SIGTRAP and SIGSEGV even when
the target process is not configured to handle those signals."

and the second even has:
"This avoids userspace regressions as older kernels exited with do_exit
which debuggers also can not intercept."


or is the patch description on the second patch somewhat misleading ?

--
Thomas

