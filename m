Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B619567069
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 16:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbiGEOJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 10:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiGEOJf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 10:09:35 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8707918C;
        Tue,  5 Jul 2022 07:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1657029622;
        bh=JLNG6qQbYegLH/nISdsYT1RRx7ezCza6UCEUa1YsOBI=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=MlKRhxYuHsMqqAN1eyxdNeq/nW6MLd238IAXi/V9jUO/oAdBxM25CVC7CaAyN3K+B
         C9Gv5o+4GEWMN8xmp4Xo0wi9TrC/tFwvKwCudj284lQVOZeNmMXdx/beEkRQZKhL1b
         2gXGMaG2dRh9gEcGDvRM2UmduUVKvSut2OP78gFA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.33.105]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MTzay-1o0RLL3ulu-00R1Gy; Tue, 05
 Jul 2022 16:00:22 +0200
Message-ID: <97a817b0-bb36-8433-28c1-c43d40e7d354@gmx.de>
Date:   Tue, 5 Jul 2022 16:00:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 5.18 000/102] 5.18.10-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:s6xLcgfSYwpdeNKTB0cNv0JntjQlj4p1ynJnHCsKyDhIHKSg9YQ
 70RGK2l++17Z3eL7VzdwjFBDcGKPMhwZi6ri+dbBXf9MT9GNy1O8pJzBC7XNuz4ScYqWj7l
 vQY9YB+aL2XpKtb1QzYFfPr9Wjr6ZvuHL6EsempIooHNkYznOmwMa+CTJdQ/Fs3vxZ6bVfj
 pYHx6oWsJMcSI9DAj1OkQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:r47WwgHunOE=:cThFB1ahH86ZfM9SJq3TzE
 y6G3JO+ozvwUWqop+ObViMuapRpvDwLY6YGo7Xv1Z7sSGQRgqmr2vVnQcUK6tM4u/TI6hx4Hi
 SJ8t2j/dsBrpaXh5Ii8hBoe/mJYDMkvREe9uXySOF9a0/dwsCNyts/Q6fvdS2JkbZr1VJTi5M
 rT0jC+AZOuhc2boQSWwYcALQtra+anw4bB7g2RRL+JLzF+A/i3FAmVZK4QzkTeGfa+7gaJyKr
 LxahSn4QPyNI1BZtVBQR5f8VqnqygNKoKid5kS1eyb1kD7ZP4BKUVCIHBs6vKl7X+Lw8aTOua
 26jBTOKNGL/wICiYKYyy7pH89TX9d0j5+BOif838Qq7UOl7HLonrV2Aa8GZc+HiAQtcEMqvz0
 FxsX+1abW/n92sf6gHeKpgy42AEeV81MHfkpNSXYI1ifBfUH1rrtbS5cU44Sqf4vc4zV0DaLk
 QTCozUAj7DRtoSe4ThDLAdgW+//p6LOPYGXnLIL2CDn3E4DR63YkjWGluT1k/iq9kvF3g3lzV
 KhUXkAGztMeH7AdC+ZZiw2RR2AaBRkkFCB2tRPYvZUGHcWmO+HrLL/Ta652iAJGoWxtkIDE9e
 7uB9oyq2H+UxTUYThhHo7CJl7hfWSxE5QVVhVWVqVypslkWZTn/FObYep4rF0kyrxI0V8QOs0
 hksl5zkoWfakjRtEk2gNjT8KMDoMZXD0w0w2YLlJ/DNnoILz3UySw0VzK3qoDep6kXjzeUKXw
 0u6uqBRyHkqXShO/oMySLYLkWJaV/B2f3mixGCmr8uJ46rvUDZDzO8teiP4rXS/rfSUwgX0zQ
 iLa1sj5dK+EPq8AbRhjLKbfWygFBtYwuIYt5J8DAg9NyZQDyUGNtD0axPHUATRPL2EDD2ol4R
 1fVDO4QXe3WtKA3Xwg2UV8j6NAPcZFbtV6Y+lYUgcxg+ZQnjOWCv4KtCjpTGOk49kGivHo+xY
 9/bFXVpCSevGpaDodeS+zp5T8kR+K/bSIJ7Gv5Eykhqhljl9fhixTlAis+kQSbBFKPuFL55ot
 gta/+MQFv7LajSHjW0RxVTvLLjdMsgFGEkMj7/qIRLV1cwO5rEEL0dqqz4W++45neKszY7KLN
 BnW42VJxfjjOXzocfy4/3sLFm4dDMscKJS4
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.18.10-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 36)

Thanks

Ronald


Tested-by: Ronald Warsow <rwarsow@gmx.de

