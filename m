Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8986B4D02DB
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 16:28:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243359AbiCGP3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 10:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243768AbiCGP3I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 10:29:08 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3733B2C654;
        Mon,  7 Mar 2022 07:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1646666891;
        bh=qxBjB+r10SulnaovpwM1ryMQRGGbf6YFHSOeC5/Qi8Q=;
        h=X-UI-Sender-Class:Date:From:Subject:To:Cc;
        b=PlKhOztywvhKDpXMDEBb1vOEPbd4nZ37GBeq+JME65BjOBZv0dxQoz4J5JqePIOAn
         UyFBj0tvY5dDV7rZwDU8Ir4TS8HWE7VYE3+viOe2jsnJ8LrWRGz5bPo6auCeBeT7sO
         ZhcYjvhcprh3AtSbIWmfUkueTr65+W2UbGn42mUQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.34.30]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MbzyP-1o1Pds2ExT-00daUx; Mon, 07
 Mar 2022 16:28:11 +0100
Message-ID: <823a58c2-4db2-2784-c54c-5068b003f1a9@gmx.de>
Date:   Mon, 7 Mar 2022 16:28:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Ronald Warsow <rwarsow@gmx.de>
Subject: Re: [PATCH 5.16 000/186] 5.16.13-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:KHdRCNVQ/T1QKkI6+aBldOAHhgE4Mki1A/6jP2Fzy3tWN9P1csh
 EFl8PR89XFkKOpJARB1LywomJSdX8bE96B3B9V2eWGuEJTc0v9tXjSW/19W9q0/jvjkX22X
 Q6ksKfMkIcFQObr/th4rQAEGRu0LoOUVjvWenWLE766fertoyOKF0pknMha5Vs1CYZVJyxn
 8fcBoSh/wALlid78PLgdw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:vLsqEZ9wpJ4=:kVRhMrxuLJWl4pSd8sOdeJ
 Zkr9n/vy9RZMBofTuzbM2Tb/6LjQfGhlemGCfp5IC4pyTCDEE2JanLmFlXaTBl1rxoZZ/HAJW
 svx7IUyLY05ieQYCJkg00t/c0CNoiZDPJnlhbG4pZP37dnjUluRD6+8wuoY9xBzO1HxXj9WjB
 B/WhX782PYxxVDNVSjodptcDNqgheeV20JlYUFbVqFIavd7QWrZkZaoTFxzxT7GjM/EA7v4G+
 IRyLpQYGcg8NqPEnj39XdFNUpsbQvIa+j3OQahYCxFPUY/o3u4TsPfEN1wVpaQMqWIT/aElrV
 RSskD2EEjm8Sarpaq7U0v/iokuwXqsJ6RrPeO+DvWiVZpNUDP3KHxduNfnAFN214F2Eu0wZCv
 BBDMCvCafMG9fIaCWCuOZ5r/IJZX3okZl4nL7jY8riFkVPsCiE5Emf6DPUBu71+sBpB8uTXPs
 2m1D7k1SqZ9BVZhAOoDpgRXQb/IsWiDi1/KfWBHopg9tNDU4a3Z2pLSQ48D/iwXpKH703vmAS
 jvUrT/BiIaWZoN/c2/qf4wQ+Bje7w7aL6MiyG9WbCDtOZ8r+6OubaHUYd2zLZZ3avPfe0IiyT
 E9z4k6BTIXFXwGegSxag9bNcoBPqsP9DpTfck6yXWUOOv7r17rMFzXxUfhfTmUF9VgwjzqFUs
 AG//qEw0YNPZ7bIqvNEo9+wIjHsAr88wV16jS4Cn7L5eBn469TfJqgl/MwEjwoL4IRzqZKSBl
 tTtZgDX7V6omK3nQ+XLPzrpH8vEy7RVTfpKr7M3zAC4aEOFj2d1Ie55fh6/rkOyTZq+VLtSxl
 FbCBaQLLIBwLXeI5ejwas1qTdyEl5liJl/W7IoA5QSU4IL5audobVhCHtSy+mrOqKWHXSbrev
 7Y0UJnXVZ3abk9E68+Ts/tiP3j4takDPInwO3jUnWGNOOmpzI77gh5g6XF7sMfxpBWaSCQ5QK
 mpCHk6/K5MAsD0c73ifBv7K9/+4JAfiuyyRLn2wmvL9pd4ZfS27UfdjZy+WeVvpCGTYOuLf9a
 guwyoUe/rLeAp2S3+32KTzup6JubGOZg9I9TGAYjN7cWa+XicGGPX/SDVgZ6jPJJ8b7oG4CKe
 +cxSvt9MLuY4Hw=
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FAKE_REPLY_A1,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.16.13-rc1

compiles, boots and runs on my x86_64
(Intel i5-11400, Fedora 35)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>


Ronald
