Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5077846A922
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350164AbhLFVL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:11:59 -0500
Received: from mout.gmx.net ([212.227.15.18]:45151 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350115AbhLFVLz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Dec 2021 16:11:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1638824904;
        bh=maLZ3Znb1Sa8qn/6rEAhsCpfmY5KmmUj7CtaI/2QRkg=;
        h=X-UI-Sender-Class:Date:From:Subject:To;
        b=F6QevkJmBD1W3j6WcT6RqSgcimQafch4AfaXEiGMJCj/VQdFy9hyyi0SuN0S1Sfrr
         KiImnBjSkj8p8WrOJFJJNjHRNdnIL315Zp6rgRrhH6uM4OMOTwbsukrWP63vOQVfy9
         tAC81DoIuj/NTawME6SZNA0LrwbkoJm/11hJOlXQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.35.26]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M6llE-1murrC0fAE-008MSl for
 <stable@vger.kernel.org>; Mon, 06 Dec 2021 22:08:24 +0100
Message-ID: <a249ac61-801f-ebd0-0218-f57a771de24b@gmx.de>
Date:   Mon, 6 Dec 2021 22:08:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 5.15 000/207] 5.15.7-rc1 review
To:     stable@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:2MiGPzHqZbUDFad8CgG2iYqE3VtPchdEjWxVjo2RmFb6SaSUXGQ
 zX35QIPwEmc3od7JhJpaTuF5qeI4EY3jwERCuSD3NkjXqIJp/+/IHIMAzpUwYA+N2PtSasd
 EEfULvMgq36Qjh1Se+znjRF9sqq/qyXY/OgTolpbGY7/9y439mKc2yh+NtCWyjoRXhQCclD
 vschJeXSLC4kVO+z1g+eQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:xcjUHmTXCTM=:d2FQ81nRcXW2v5UwCnNmUk
 ae76aZPXybWJB67vlzwTZ3sE2IyfXWYUgkEeVdYF6KslVtdE9TrmzaGtY95L2e9tfAZx+zE5X
 XTAKs6Je7tQwlc7OrBgHXzbj2ISpdGuok8V4kWm5rl/tg7Yw5UA3A6hDp7i7A6vOGL88nY0Yq
 NGnFF3dDlt8AKKXrZx7D3eAEt80WWXLp9TQsyiHgSjHei8+hbnNT2g+7jR9zV4DOY34pr8DFf
 1dDmh2qs7fcy1uziGj+3FCvbCcQYir9cdjl1YOXkYxLoI8NPkptEb/bNpbLift8qL3sN7wTRb
 0/yS6ZR8z4vAemqqKjyweERifxN4SLSWu0UyZGUzcNAkPKYnSLgzRpvxtpGwERfLDQHjeCSRQ
 FahjhGFmYzurvUi7I/1BuV6449eh3HpVpsnlF3CktsHzwEwlCGAd/BegOPEfB8085wcW0VMSO
 Vj5vbOqYfGyMeD2ArhC/SPX/t06dVqqoHdYkuLuxWuULHd/XHOmmh+Uvu2PepdfZCjTYwC37L
 T05IXWjL1X81Mh+EReVb9kGlS2/wodzSQhlmv1/sRtmelJktUUBmcJYt3ZjTYIaIRCJ6Bkslq
 JdlhPFa4jm6Z6GomaW73NZGHVn9H0TnBAXdN8GrFWtYC5dpmaaMQ6DZePPIm34kosmDT7gflY
 VwXltQxPsnkjPioCzKhk3MGrLOMyB8MEuTvHAG3R5JTFxEJzaHoa3ciDu+TEzMfXNz71n0eeJ
 6u/P3sN3XWptyRF/2CVoD5tEQsh3dMrlu8Cj6zus/19ikBkKcpfDwE/nqsUpMdIu8/EqPWw6R
 82Tjy3rDqMM3i00S3sIjM0zNPpx/wZKitYzuTM5zLoAib3yTFZ3Bfs0imHWljf4t2RboSlXpE
 pN+fePoxTM8ueln1XpLqbPcmfnZKUjqAo/srLSxQBsFYuMVXQFqb1UXe8SrEj3JITYl1JKeVx
 zJrt3DfcsV5Wa6MM0WQwnhDFf/M0j//XnVrGDOO7GlnVaJSnjrOS68h+Soy4q6VVT3rMqD8uz
 FPxNNaePC4x6+/uIGhK7H64EVjuN+G0g1gu5XiDII5/BW+2wf4EmTBdf/idaM0QcTG8+yq1og
 lvgkHDPfyrSyPI=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

5.15.7-rc1 successfully compiled, booted and suspended on an x86_64
(Intel i5-11400, Fedora 35)

Tested-by: Ronald Warsow <rwarsow@gmx.de>

thanks
---

Ronald

