Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC6F462A0C
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 02:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbhK3CBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 21:01:09 -0500
Received: from mout.gmx.net ([212.227.15.18]:42793 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232152AbhK3CBJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 21:01:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1638237469;
        bh=hqg6E5t4awXX3JNLr2yX0h9W3eNMEcDR7674htguDMs=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=TLKp+ftMN+z4+9Ye0TnOU9Ma4wtFh5PLVOPnUBI6kUQaznZXZjuH7sELCOKyTXf+O
         mEypTrSbiPZgckapwyN/AQPBRitGwgPhTVHThQDa+73oD6eF2OjxSON05pJ6VH2K7J
         C6LAdw5IlQgApV0yKbFw/7rBSaX0URNcvoDIjCPA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.34.15]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MoO6M-1mGOzV0qOO-00opUk; Tue, 30
 Nov 2021 02:57:49 +0100
Message-ID: <486ef17a-e26c-5191-f76b-941e8e01ced8@gmx.de>
Date:   Tue, 30 Nov 2021 02:57:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 5.15 000/179] 5.15.6-rc1 review
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:l/v65sNoRZ+O9sjB8c3+loU+r25OGFpBdrssXwtr8C4HnCw3kpT
 XMorhBe54tSOW1m0Ph9XdSo1HogejtEiktG/fLXoDyzXKVr/WFMS6v+nn3UIg0MxpYQOQyM
 0n3AQVDS69Pu51x54VVfBjO206w6dK+gC0+Cfkot2/TPMpTvFvRhCZtth/kk9Je/7eXGa5Z
 9YFDKguGH9F7VijZqOKsQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:6H3KpLfwxeU=:lXEDhlM0K1QEjAa954RYK5
 mzhPtGnepmApYyu2jPo2B3jsfHgrtI+8u7KzudMPin6oTEmQhZAPmDp8kGTNp4ptByeuc1Dzz
 XG5ed1e+19lH6O7FfnLqHg1lMnXzHHU2+5Dlk+kAi44eHK7uvOopvVKBXxYS2JiCPfNPZbrYd
 s3XplkSTf5z8tz6D7It7kG2iTML+WcBg2VJ7ebf9rGiiA8as1UAgm/OOpPktk2mSc8GxIOMQU
 YJgn1odEU8XsKAJDP+nsi1tDKhCzQ1k3IEFMNUp6mR7oa+2d0ZcG91K/1z/7cEK86NMp7EnAs
 GCGTJ46RJ3wM0rfAlzIEFdnBf0Q8R7O1Y7L+MOoybs12HmYESThXDLZ8RWrCSSYGrHjmtQAuu
 l5BQv9kB3EMDSnY7K6GL5RGVrCC4YJG5+tFjQbsDeG8CDAM8hTkZaBTbvDWOOHbdlDuhkvTVG
 9iIN+r2T1ZBFkDpdXFcS6DDwLokEaJtVeTAK0I8DV9O3F0pSpnZ3eUvN+2Nv4ufqi8FpY8mG6
 nEYCOeX+P384g12uQc2myAqCUkhVIsrJzvzCsdXs5dvcfSDRvgIVHRTIi1alVkqhxI3PAG1uU
 DP1ZeQvglgdFcs3YfF0PVvpReOzYVDxSFQCDcKl65HJcnyReAemWwb2dDlslMCYmX2h+DrBit
 1fMmAOKbX2yHFVuSbcT24TtcdodqvtQ9DOVxr+zoIlVsrilzKnvXUCnnGnOIVmDu21Z1tHui2
 OMEbwfFOONZDsoW631Nuzh+iroGz8etPxOwuH/7fePoxueGIxtoXfGpOqOLG0rzSgqz6btEsJ
 to1ZboA3b2Ggsj9JfQJfIkF+K8/POg4tkTqUq6guWCVGphBbrNXaLR7yHR6u/c0M8lnpUX7lW
 bwbII49s1BoxPd8FuVldQbmlwdTarg2ZIJsvmqQLKNVGMvveeIED4P66XXnWk9uaaMZUsD64r
 T1DrvbaObDiPTSTs+Vnly2a0ceKOKiCE89+zjWD9xRZ+8/53oItRvipdITygB46Dp0ZLeB3am
 s5oqzFKFsXjKGayCle9RVdLJwf2/EXJlix5NUc3MgjZduOTpnP3BLUB0Bzm9IilB4dZ0D6Qd0
 RljT0WXMX6xWUM=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

5.15.6-rc1 successfully compiled, booted and suspended on an x86_64
(Intel i5-11400)

Tested-by: Ronald Warsow <rwarsow@gmx.de>

thanks

=2D-
Ronald

