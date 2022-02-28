Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A2A4C7CDC
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 23:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbiB1WGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 17:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbiB1WGR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 17:06:17 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195E6C4B7D;
        Mon, 28 Feb 2022 14:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1646085935;
        bh=+7CzihnzgTYmCLMqEpbk+PtpuBNYVvriFBEuVuXL4Bs=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=On9wmHuU6ASmmwO6lP3MGz6JPCcuUycO4fDErm6oGhHIy8OhMn867mg9HUjUX7kOV
         W1UzyLtf6oyBhot0LwbJZyBsnTyn+6qy8YBvCT0aPYpYcQ0qLp+y5YziVfONpClwNK
         PdeAmAkHXPXu9npnyDx2yBzargBblBkWAx7EvsUA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.35.38]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mjj87-1o53dk0c4R-00lD7o; Mon, 28
 Feb 2022 23:05:35 +0100
Message-ID: <5d374df7-20e5-4276-2ce9-a5114843a026@gmx.de>
Date:   Mon, 28 Feb 2022 23:05:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.16 000/164] 5.16.12-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:Lfo76snrATQIXwaDF54augeUP8Uxg3FRNVys0l9hKHdqkyksKKn
 cY241IhaheCb1QdG1TsXBgols3nf4JEDBDRTN+rc1LbT9Ui1Hf7JLaC/EvKlazl8RH4WbG0
 9TKUblv9NZaMLlPKbMWhWb6t+S3k2RWKitc8tqb2QLGrMUWalnbkBd5wTHLC57NMVdVnERI
 b/LknXlxWfV9uXCFhSBeg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:12wNYXyyyXI=:5l14PSB1yKKRSHwob0ryJ4
 rGGMW7BYpcI2iekpntDfs90hstBpZFeQhn6/wdL913RRnUMDIBOAELTc7Rfh5bAneFmS5t+lA
 MOWYdyDgAh6cGrWyVRummk8f0IP87pInOQSEF6suw3WEy6FwiqaLkBPrdXYmJZ6cd0FQHWCY0
 FnLPPoWYgJuAZyUdiXiF1jUh5lHE1dIfEKNE5k+zlZ4VNH+4IMWthR0QISgKebhVwv815k1Pm
 Q7PpVxJ7mxunwYVwUN9IcEzMOmgY25JJevwuuvSZdH804Q9f7TklL13ZWsfYVHyGUpFfHzF09
 15MKXb3cEhNPcyvo4BzHehoL1l4x91L+EjbHt5Fz3L73NNDaL2oA5S3hMv3Fl/h00ZnwsJ+Lv
 q+icxXJy2Tk3GjcaH4AMtXpIbP5zg6xZxXM12MpCCEgR19uuHyK4nIDun3apiIxi7rWVPgpYS
 loO/x2V/uMx2RsQY9a2XQNoEWg8Cf809+KGAXwqp3TGpu5v3aj82qwxGP0gb2z9mAOuOOMmJ+
 9s9y0spr9fD61WBKFd6WGCNIfxWUv0dUVB1KYMfnjomubbUqI4VMgPUAndDcDnvHw4OC07dAY
 MkIloPH/4gc7HHVQm8kjPfVH/S+0WIx2jNnX3KDU5DXz4PEORXoXkDOi/9pf66XJxvswoKrqH
 7e34kIPhSK14Z6GN4Gx4nCqqEaegO1qvK1dE1OVJ6bsmrVQnmV7YfSGXAo6ZwKW9dRq/dA8fo
 nV+bxq2CkKGny+k/9cDXoKStKi+zbvhInCBVarHE79KiDiA6tKvhcQeRNnv18v+OiFU/qqjqS
 sWfViTV93XByYnWHn058vLnGjsCod8nl74nuU+bKDtOXPdXxI5l6LDj3uj4JLD+EgIsAHQR3W
 tnQprNKn4akur8dTOthkwWwjCWYcbHwKE48y65vJI5qiS9lOMPrITOYTQ4mebsvArrSEq8txg
 9L/YxOty+ng6Hbq82kkYLaoN59RgNKpIxABbieSNrnW1+GWf062iRerwI6ad6ty+ROVuHQwUx
 DEUeTJ5Q/kBD5jHLTPoXJBkWi19966z1plVEKCejt0ur3yhNX5P6cc7lTqE2GuhgH+BxAlRWf
 rS9r8SZcMqm0Ow=
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FAKE_REPLY_A1,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.16.12-rc1

compiles, boots and runs on my x86_64
(Intel i5-11400, Fedora 35)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

Ronald

