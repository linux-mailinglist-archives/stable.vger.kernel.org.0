Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4EE69D54E
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 21:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbjBTUwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 15:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbjBTUwH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 15:52:07 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A19C7EDC;
        Mon, 20 Feb 2023 12:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1676926324; i=rwarsow@gmx.de;
        bh=Z50Va+cpon0wV2h3lbmhdnICZt1BGnwSH/yeqkJPa3Q=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=tF2VntlDv9XmcNLE4D5Vq87I2vdIllVCfRkQYt1pm+m6Vix1/gsCu/Yjlhqp7JA+e
         xADzQqIXdYiiu4qcuH/xz3RqYPo1PUpwaZ4Kh9oAEKFHidVZ9Kg/dFjFVENzBfG5qa
         L4T9Pm4aoAA+G+Bxlt6/+C4k76r1MNNXkiH9hEZ19dBmBQptQkBbZHcJRoCJwg/4LV
         BecaQ0pLMz6OT3TuuOurVKJSC4me/TzHESS3gipZ41tr9g3Jdie7lfGuEA4YICfPUV
         KGGKKGgrIY/xUeLbG7ut6sPjW98k1Pr0rSj7pa0GHsh1CupYr67ZVybMpw0GXN4Z6J
         KSwdIrFGPc59Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.33.120]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N4zAs-1oVXSy1Mpw-010vk6; Mon, 20
 Feb 2023 21:52:04 +0100
Message-ID: <e7970821-017f-df54-85ee-66e7cc61aee6@gmx.de>
Date:   Mon, 20 Feb 2023 21:52:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.1 000/118] 6.1.13-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:ifcX1ikFTabIyuEktYmnZTMkrhs/ZEv1YZsDZUE/ZPAXzmeHfBv
 JSioTobIArSoWDaFzwLnfv3rcO84Av+Aw/fdX6MlpO4x1Cdzm9OA9Eyi8q6Ik7RgqqGMGgh
 hfGGynJQSfacXvJQ9KiBykkQTPuntdBoarWx+cH3xOSNvQekcYfo3ky0HcMJrevm0e3xyVe
 fLQUstAXAbjB3Q7wxmmWw==
UI-OutboundReport: notjunk:1;M01:P0:e5uGblQIkNY=;vy2nP7KZZOVbUvylZP76LtFlRDT
 VaRL/kHqOPyrApeGhOGY4vMdl9vREheSc17zSGeMnAq/rGWDiF7809qYR8AW+gHmEOmZC2Uaa
 D4sEx/9RQvrU4tzfxc3on7ieyOGRSldUlLoDNuXd6dfD/t63uv0bGRMhAwCqcFJnYLtITmR+i
 25HGeBoSQExNbQZyPi8JZnzDt/ExFwiqJC0vGey6Evpt7oJ3mgdkOElvcsA8D1qU2ongi6t+8
 AWouJf0kBrwhxKK7rh9be0k4wxDxJxD3K8buG7RriVAoIJwevqgEtO4xvNCqNVOPbTj9ANZuy
 oFM30SUXJ/shh3GF3bzy2OEFYBusyuxWQm5byvUrtMiu0wtUDofNhKOwzE6luSQL94qnnXBzf
 SoPlRnhH9zKAFbXaIf4P4DYLCuasSKM7vQl+ql3jR926CX7JDREpHYW58GEy/Z+QaKmd9bopr
 rdhcm0gn1cj0oSDI3X0L8hM132ekQu3cX4Ow0OAjLl0DkD9Vy83uQX9tG0bfYuK/sI4kmmglB
 aqdmtwNOpP40Rk9qKKSdyssgxkBG46QXJhzckSsnoZh3z0MSb/fonXWHlDVxA7NVFQdvSfnTI
 ieaemqirTmcUAXisWzCd+p4i15ELEivhY6xWTMgiRQurunX0RAuRnlT+FoIO/2jZXgZKDI3ka
 NimNHO5eLfaa4IuXWrTsrD81wLv+LYhIudyej5LKl45vLk3v9+Z0w6h4jUFJWf3GrOgiwbCo5
 nUVEmbkUVuZ5uxHdoAU0majR1sz6VwDE8Ilgup7KwWAbtg0/OewEZko1X5W3s8fs2BaCrJXJk
 lRH913fzwv9lgtRGC/8h/R52ZwNr1iSn8VvZUlclnAkA68UvfsmpaAU39cZCX1tEdVAzOefjU
 u61QaB6rGsf80dq9rUdg+gSUU79rmKexPWIzV5h+uEgPxqvcPaRv8c3/Ii2S7ahxvOGR5l/A8
 /OGON7OWvTQhWoQKqVR6A1+Gimg=
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

6.1.13-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

