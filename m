Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED38681FEA
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 00:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjA3XsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 18:48:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjA3XsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 18:48:22 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA062B28A;
        Mon, 30 Jan 2023 15:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1675122499; bh=7QEUvsM6RZosABXoX68ZthMpS/pPOdW8RkhtKstwaLU=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=ohRb2+ryXS7nr9gMy8MDtyY+lm91nqndRcQA9dScoZOSPAozOsxsLGWId6d7po/Z9
         0jJa9W4QET3izh3+5ANIbtqJTWlOMaKJYudepjP2JT+fZRb7Y7KHqlkh9C2l2sMrK5
         hfOLOvNN9N15S2H733RjKw9+64MUX8dr+w97HkBeCu83QDaeOogpIJPR9hF6DzYCOM
         ipUxd6/XclJgsGIhwvu+0QxQIv2moiDKO0Osj3HyI5O4ysbWtQUtwT3i3EQWyeIDx1
         dZZWtxouoX+V56IUKycV2o2Z+wNrS2Nt3jZsfDpLv5JlpTqEbotJ5tOjNRM7qaQ7eh
         RlVMLOvN+nnYg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.35.76]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MvK0R-1oWBko0Qcb-00rG3q; Tue, 31
 Jan 2023 00:48:19 +0100
Message-ID: <4979610b-c445-109c-1ac8-02571227a41b@gmx.de>
Date:   Tue, 31 Jan 2023 00:48:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE, en-US
Subject: Re: [PATCH 6.1 000/313] 6.1.9-rc2 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:Qitjl8AhBkSScIbauoQG3ym8tara+84uG2pyUDCeanpn7Kfhx86
 kEyeZ3WVPwlj4AIBjKD6JDxJGb+OLbAacIlR1BziK610+gsantPvqw1EAlpk4zi9X5Ete/G
 vNvTMCkXKwtblVu3tPYL0J4iDjICFGxbCxuKtlW5vr8nW/+Dub3M0/H4AXyC8l25GkRSUNl
 Vu9ij90ZKS+EF/fRISfnQ==
UI-OutboundReport: notjunk:1;M01:P0:SPSEKDKGqWY=;QemtszIiwCqnCXayO34EmY8Fn3k
 D0bDngd1rsVYx3w0c19BO5+DKmZv0v38c4p99FF382jVJGAmmPdunPuCGcmwZSPJD+MoukP/a
 QmjwLwGItNvRw8YUpLcSz7mrCxYca7eCYFj8l5iFWTGU1YdmUpw1Mkd5pmp3+LUfwM8Atrp6D
 DBICVrljcqtAKVvj35yMuXJnuL8GLRlr3hmsEvySl97TntUUSkWDZkYaVAdiKUInga10LRNB5
 DG/3IMlRW5qovC1DuAuefhZGucCkriOZ9ga4MFfBvDF9ql5Hu+ZwKa1WKIvFT6LbiHohFSh+T
 nWE1y0VVpYoZj7SukW9sVZ6uq/p2WBqJRTds3T3ZRkiQf6R+RH29rTklOhbXJG9OrbHxMILFP
 9qHv96nzLSRR8eH8T9eB4LMkYjAcEd+9cx/hj2R19va9OBF40hINL4S7neJ3mzvAsMR5DsBUu
 bS8rSnobrSZBE5C175UfGEHmEOVGJZdltSuog6P4U3XYs0qxbin2IYresvi906HB+Otq7Jjbw
 yQqK9G9z1qRB2dmJBi+d061cxU3fXWu9D+ChxbcvWB9ZUEYUZx0ezj/cMRy/X0ZVY7uJ/Kp0X
 ggXTHD3F03Lx474n+aVVGIdHvEdFANwcRpslqiMr2h9hsh/MhGednkFSWYD4RfkIYRKZQM4cB
 qEA0JZC/pOzPIc4UnR4zcdVqm7Bx4n6/jFtUDErEHVR/TwQyu1CKWiZIty3lF0q8uXZ7WXJEL
 bXJqQzaSi5f16amlhG6JT/hanM+M4Z2Pq6rk9MXht4nfLiWGO/sOW6JWApRwysZlrafLjYbng
 m+Tl8DkzBuSl9gdRQMVnE2YqWdW5awfGn3IJmqhQ4NIWGWVkpbn4Z+I0hMEqY9Wnd7787xA/T
 8kpLWMzH3whA4F2HGf6LDgQjst1Be+5BATYlX23lsdjE9O43hmXC8IpfeRHR619z9h1wzggLN
 o+bezA==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.1.9-rc2

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

