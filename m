Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 949ED65B6D8
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 20:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbjABTGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 14:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233131AbjABTGu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 14:06:50 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2A25F84;
        Mon,  2 Jan 2023 11:06:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1672686407; bh=wswf4MzEyThjIfi1VeqmEq3dw74bg1vyukWgDdtRwVU=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=KumOgyTYbSpAhu9+7IAUaWLm7QfkxbJOLP/Qiodp4gDGcIAgUqaxTvvcamO9vWUk7
         vAqJz4s7982Bh8uRQrBfXzcv+B/vzGcobvZDsFId51sazqowuVmbdOY/n9zr3oYF7D
         uUO/XQPZC0sFV/H29jnTYhElMijVLYKwhj2YSqYViy9sSe9XOAtp09s1pbYf7k4LM/
         zfyoql0BaTiR+cHqsah2I9nuBhQLD0Iq/uNSbIv8/Oc2VnItH3wzph+o7v9yT++zhw
         U4SHPbmHSp+hNkP4K95j3gTmm7vCY8c12urAlCkKTk6VNlp78Qj+Oxk1CaaAkv2eOu
         wBd/leg4IRh9A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.33.115]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MhD2Y-1oYQUv2Wfq-00ePxg; Mon, 02
 Jan 2023 20:06:47 +0100
Message-ID: <d3e03537-16ce-a68e-89e6-64dd44a3fc5d@gmx.de>
Date:   Mon, 2 Jan 2023 20:06:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.1 00/71] 6.1.3-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:765+Dtj1IuismFmqTfMoLYk7m2JjDGpyiU+DzacxZmdv985hHP2
 nKS2VeoRSDXNNyoyJEWHyWFm8kEELHKv+FuXvrggfVwV4E324SFmTFinikXjTFdJBjH4Oqz
 /Ga1WclLLxPM4+M4U9hXC+GJFoaD+NY8KE1D5YcbMpRLu1QSUX21XkIFOhjZQnfQZlb4tzW
 IeKr7nI+hEPVpmaDmKwng==
UI-OutboundReport: notjunk:1;M01:P0:KJ/GIHFZo/4=;nRUBKCaDdZQCRf7NBOAHFPxRBfm
 Vj77klvpFIKgqWnpDJVRbhQLs4UIsfoukCfetphGRwPLRUx6Yk45nXIsZrsghivtLk4TMoXoi
 qcsvaxknKkzKvPAW0JnWm1bPxgevJutMqfi4A7poE9IsVdG4+XaHmqt2gIuu40INjg/GwCeXH
 rem7GSEiMbJ3YaXjCHh0TcbMwPX5x5u7YeNpWdBFWPMt8qasPAVNAJ4pkhBSt7LhJjCQNsFlS
 YadD95LtGDINB2N6jNT41aG7Ejc2XuhK4GDtrP2eMfCaBOFgOHGv89u3h0RrmbmnQhCjcYK0K
 qU8Zixwsju4Y7NYo+orZX8dWzJJcjICeiFoKuG83AfkPzhSjezTCal47RiQx1hmhWtXJa1GMl
 GgyLQqMZS0/fJCwh+yfLQWDTAVyeve5lt11ZZFA0HBmkiWL8OGvZdq0tVx+CbrgWll/TS/t7s
 FRlpiYfum31VIiExRljB6jgnhGOz5ccW/8R1eaPO36uNzJGNuDBbZpezEXuTMUCfnSqghxwFj
 JaFt52pzq5JVg3yKHEjAiFzcX+9U9+m9ih4+nymC8gU/jHP1AzMTMiBnCPIHLKHhN86yvYcNH
 Hlfg/NpbgWAqhuD9QNkTTE5a6On/Tvq9pnk1Pxg9uErs1w9NMl8xHnbF11ZJlGoNhIzfD7yIq
 +ZSPmBoO+YYpmeaMd5+bJyvHAkrOwgKk3heU6VJ8WmMe+rf259+pCEBR7XomHH82k+XMGcorN
 lAclstCXypFo/Epl6ZgCg/iYGz1BqK1AHHM4PtaKhNS8LYz+io2qTod2y/nIGiuJS+YoeTijO
 lBbIfqzFEk0RjPPkBIj69e3oA0JBuj2Tw3f97mKgH/q2Jpxye0pjoLBgJTvVU5r3X1V19Z3YI
 pNdj9pKPj9bRMPoY7BK2IHKVkFRmCpeDQ/24VPtVVN0jcf+yL3D/jfVBh4DH1aaZfE0ePHXyW
 4K4mLQ==
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

6.1.3-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

