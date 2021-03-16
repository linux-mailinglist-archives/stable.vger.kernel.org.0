Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9DD33D5EA
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 15:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236667AbhCPOix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 10:38:53 -0400
Received: from mout.gmx.net ([212.227.17.21]:42923 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235694AbhCPOip (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 10:38:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1615905520;
        bh=CpjLwxV9YayOxOBCFEhv6OMhBXBkEBV9glfTpF+9tTw=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=K+29/BjvYZ37mH2bIqPsUGFm4JGRjIbAmef+3dIHlCL0tUXK6wcclAFDmsiI4DlzJ
         JUOb0gkTypl8DR2fg9jZUGX0diHSCabB5hpXIp5L5E8VQTpHwMoLsbQQvd4A5o+Upo
         BoPRJwSLruFj0Mi9zVWbSHUArz2OCbK6Nz5OuCMA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from obelix.fritz.box ([46.142.1.35]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MEm27-1lTeod0ZJL-00GG2y; Tue, 16
 Mar 2021 15:38:40 +0100
Subject: Re: [PATCH 5.11 000/306] 5.11.7-rc1 review
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <ca67d634-3845-ef3b-1ffc-48471045f3b5@gmx.de>
 <YFCrUP3TPqVK57E9@kroah.com>
From:   Ronald Warsow <rwarsow@gmx.de>
Message-ID: <7874700a-694e-d85f-71c6-731e89832da9@gmx.de>
Date:   Tue, 16 Mar 2021 15:38:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <YFCrUP3TPqVK57E9@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:k9t4y/HrP+y5YzZQIG1jSxDHTGkn9tLfeQ3VpjlIUQD452Qn4rO
 ii6iQUaqIDiicxuRUzx+5No7O4nMjxO1+Arx0Rf6npphFOFKstmS11TdaWKCybAMRfbbow2
 wMg3KTFnv6yoN47T85UHmZdRcwoZ3s49uXtOdpSm8PhnMgcRq0ewV7WDNFWIy9+wQwViC2b
 NlF6xTnp+mfdkqH0+Sq2A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:D7esss3lhuQ=:2ylznTPIu4Js+laJUK/xem
 i43b9TCTBcfmQ3mxLT42c+aE89kSpUlFwgtGnHIDjvlDIzLZPlRosu08Sln2RmFav6qPTAkrS
 83GlSQ1pHhHPZ8JosW/2zJJVqrbOnwLDPTUlK9qnYvKeFP2CDTJBNJ8sl803/Ycl/DCi1nIEH
 3qVxZdHGiZQkhO0Jx113kzavZLsveeFqAO3x32dHmsZDjsrJIgwEGiLetT1Gq/5NolBPLTdUK
 +daeKRv3yLaTWZ1vKit2KK0cSHg6o3X5aYg7/twz/UEZ1KxglvvraRJkeWBxd1ginVrNBKfRs
 msgnXeTQehxQw2zMCGqjWfMgpzR4plBLxRuilqltVjqm/LWHeFluSOpIZYa8N6muNSONw2khx
 pubr20u/fKvOycBa8bZ/1tfPfHQ4zhaIFVuj/cYf/Pbxs0ubP5gG3vIv+hn2CFSbllH3qRiPf
 CFHFHY1tZ/Uan7WzoO0+eGUpPeQkZj5OgCXphC+eld4TKUdTZRj/oK2nO1vZzqWfPqEQT3SQD
 KStNwVG8vqn2t/Va31tA9HJF5fyfDBnA314AlDRiz/piE4iKBruguk0ruyeErPqXLHxWLqKIB
 OiUy22kqNIQx6m6VfZPZ+j2iMZ8vHIckB9lbVFC56XSnfOz9y8H9PEFEHHH4IbBxYpOpOmnKo
 FL7DifmShqvTuYsRn7VLg/gSt1B124/ukjw07IzwdkBmF3j6aFVdno0gaukYXtyab5fNStfXW
 zXSCIRuA1eXfZr/xAJTZSN0K/u2gbpdYvdZzzlBCv72m6Vp5WQmJBJzOrbno34FV4c6d9nuKL
 vjIF95bTAf9QqUWYqgpj//k2aI+qJLoTeES87TE+P1dkftlqrNcXUOoWlbmNYFMpefcKWuspv
 yQ1qWkMXiqd9hzEckXLg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16.03.21 13:57, Greg KH wrote:
> On Tue, Mar 16, 2021 at 01:34:31PM +0100, Ronald Warsow wrote:
...
>>
>> bug/error (since 5.11.1 or 2):
>>
>> i915 0000:00:02.0: [drm] *ERROR* mismatch in DDB state pipe A plane 1
>> (expected (0,0), found (0,446))
>
> What is the commit id here for the fix that you are looking for?
>
> thanks,
>
> greg k-h
>

sorry, I do not have an commit id.

*An* error report is here:

https://gitlab.freedesktop.org/drm/intel/-/issues/2708

and the fix:

sh*t, I searched and found it yesterday somewhere here:
https://cgit.freedesktop.org/drm-intel/

but can't find it anymore now.
Aaarrggghhh !


IIRC, it seemed to me that a fix regarding the error in(?)

./drivers/gpu/drm/i915/display/intel_display.c:

was ~queued~ in one of the *next* or *fixes*

I've no idea which *next* or *fixes* will when go into stable or maybe
5.12...


sorry, I can't help here much
=2D-
regards

Ronald
