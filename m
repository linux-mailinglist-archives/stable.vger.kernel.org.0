Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 222DD505BFF
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 17:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345774AbiDRPzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 11:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345901AbiDRPzX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 11:55:23 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6427C32052;
        Mon, 18 Apr 2022 08:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1650296562;
        bh=7nSGdcM8ssqXUQMkFPDfbxODCXKpWyTY0AEUlY2QE+8=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=MZIzqJDmtClIeW4A4Xc8bB5ePyFUbjiLlJZ0RsrhB8wFm8AHswk0ncpzDmkggux5o
         oU6BtkEB3tYtHukiZQPQ/6UE8OIn3UzfEqHyUEypwTP+TGn/xEL26K9hDci93ZC6KJ
         lGJP0kgHk+hJPJmUjZnDcdwgDrS6dPetFItr6oUo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.32.119]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N5GE1-1o5SaN1vGf-011Bnd; Mon, 18
 Apr 2022 17:42:42 +0200
Message-ID: <c15f209f-633e-b7a3-26b8-bdac060b63b4@gmx.de>
Date:   Mon, 18 Apr 2022 17:42:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 5.17 000/219] 5.17.4-rc1 review
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:05HGfcSZN7sjkQ8FVF3KgeZclF01op09qZqvCYoKe3hpSbbEq6D
 uy6BGDk8hz4EA5V3Gsh/G/kTB0AhhySKtWcjEmGt7tKEKGAeP3LAmoKbSIz3OenkBIejbNS
 siTa59c68H+ZWoqOV8eK2FGCGtA9sIIz2ymRN1uCczReXKXfm/JpxY9QkTDKDSGYuvm8cT+
 Ekoq/fO+erIoxPy3yWcuw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:x+N5joyxTB8=:8j+JTtI/tfu5Z/nWd5JWBQ
 tYu22rI4Z9E93r9PCA76XVWng3MuFYFZXMB6GQLaXTMwOHQhGzOtvSz9V+wqJ3o8wTYwqloji
 J7FoQj0vBOIiperRdyYhw2FBcb0sR/jNTQDRe6FOk7M0nl6JQ4/SDdMC/IBX7oD+/ZoIILuXL
 tdlfYxpDkYMXsbb8hEhzs/77ewww0jzRslTo7LM6bxDWv7kRjxb4Gwzp2ONmWiakYa8UrD3v5
 gFb7KkW/YZ8IgioJn6X/tbT0QQMMsyCX1Rk5wiTuY/OBNIJ9G0iwlwbPDgSQ0TadtyISh/O7b
 UHhKk5qKsul8IBVxXzPz3hgoykvinv/M5KlmyUX7HeK4OB4IJR4fqsKXcyMf3hHOm00vxe0Ay
 ll+cMm+Kfuv+L8flJrkBWbBw47eDiHVJY0RV4NEYZji9aUxVwwHWaqxX5d/UHdgIDu0aok+45
 9PTv64oFHquknEU12HHqrLu2nPazScI5UJic0NgnUbLkD9XhCg+Ju8w2fLF+4Vv7kScx3FpMp
 klf5S6iqhq+/Oq1akmW1ddYtHiVqPduzn5v4BIFIrzQGdwdhwJYm/35T99hrNX90atOpa3A4O
 TQg4BKyRh7Z3zfVX0Prh1bcSETZEgEzpGM9qp8tlCltgHKn1sToiwIg5SNuNY2vvqGIw8NuMB
 vXN7vh1AD2H0HnpfBEjpmPjt+lXP5dxS17onQW/n4fEV5io+DQ/BdVlE1VQEOKSeCAf/QiSht
 WdgjpxdazpIY7KbZ32Gkxzi/BktOkO87sUyzr3U1zdbrfBB9Qswp9bbjKXHBX6EfQkpM5aluy
 097zMwnyfV4Gmssw5XbUYbJh39s0tBkM0JBOIA82NHRGTU3f99FW0xgIpXxVTuEQbPdlQc3GC
 5gPF2LVypDUa5K1LCQkgnhUGQB9ewTwp1+BEaZ6dYUYZTHA6GX05bseGuu98Yfi8Zz2yHPIoN
 dhWI/4JITZTCUyrYZnByl6pIawRUznyY4MNsc6/fIeuFie2LpJMUFJH+EIPfN//ZNJssbmt9m
 CHTbEa4z+2dTB3HupuaxR5LHzGejw8GcWK5RCCi1CAo/+DB2AcoQ+QUsvkW9ttjGlX0I4ZqQe
 +QCKXGxSQg4dVo=
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FAKE_REPLY_A1,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.17.4-rc1

compiles, boots and runs on x86_64
(Intel i5-11400, Fedora 36 Beta)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de

Ronald

