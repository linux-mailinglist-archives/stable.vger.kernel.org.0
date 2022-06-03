Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C3353D2D6
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 22:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240604AbiFCUdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 16:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiFCUdX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 16:33:23 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BCACE09A;
        Fri,  3 Jun 2022 13:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1654288398;
        bh=VoWXLCtPUI4TuIxXgRZjDEmtacMUqoKfVu8X0ezR1HU=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=Co9jLger6zrv3n0d2m3AMN8JWAH3VewxF/KGgk86R5zgCxd5Yzioc3OBTSMBWMYGh
         2HTzqhYXK/g5dyZ/Ki9aE/iPYkEIUlGmLmtXTNvGYfh7txR9xgbb07LoPodppg9KF7
         ROzIYdw9rwEdCZAgJcy/v4deltVLXbx1qjNPgwLg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.35.224]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N4QsY-1np16O0fPq-011VSt; Fri, 03
 Jun 2022 22:33:18 +0200
Message-ID: <7217b8cc-f50d-2633-29d1-9706193e5932@gmx.de>
Date:   Fri, 3 Jun 2022 22:33:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.18 00/67] 5.18.2-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:NwBdrgm6DjwS5y3yWuixe2IqXXdDmicnM3pSx3IU8b0MPst2f4v
 GW5xVpZLHL1PABye/1XbN+1yiT9Ahxof21tfMy/9RROoERXouYUNB/GSYM6TUQiB4Fu5Gq0
 kCcYBi84E9JAL4QmHuyfuu/gYAkBjoBAe5vawfwVD5jAEvFdpvsC3bWNbrDxJvXhNVl5C6W
 d9SMHdeP4c0pxb6fw66vQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:coIjRg5LKCc=:PArP4Ll71SaZ/YI1P4PJ95
 xMfbTBnMzVLsAUfT0PztbP1PXa6BJu6MrrHdVilHwesH42gHRjjnWRrAvIL5rWpzQqDAIFwvX
 NjbEsuAAsR7VrTnMZIDbez1lzWiKssaNRBCX/hLhWNPXDJ1KMsvf042VCkizDUyISTsvA4DKs
 +TK4Q84GKyR27JhrPOUzQgWUcSIIKHITu5Vb0J9ZBb4i5IYuLubY1V8VvHjx0vptSSHx9m5MN
 4pwKla/Af/xblUdbBffI10ZA947Fg1hCUhHnkiKmj2OpAWiWFWhyfHyK5LTv+lf/S2bBVoTQL
 QWqYLwjpdMa1HQmpW5uVX7j8TRT4VyeET87krK0cA/AwRXqZzPEg72/O2goailT9zqottM5Hr
 U/LayoH7PsjjHe02vt4XlkHVs7iUrmp3QWpKOT3xXLTZP2tGX2w5nQAAg6yRprYs7iMsKGlJP
 jSIzLkkBEfkkjpVZlprcTUcwJat3KNPA0allux25xgdtLVedPkVbpV5q4wQAOu8Ny/2Dy0nOR
 B1Gul6Rx+3vbEZDCA7BMdWnVeGI3kKuP3UcNgTtCuMV0Cncw/D0K7mFvHnNqGmHBgj5NoTFlY
 DcdfpG4385R5tK6BRu2RyefaoxVQeQ5SC7j0yQC3Tv4QK9UAD76YBzQbzj7VTMR2VEhFHAllu
 Cwj8vzO+Im9Qlzq0l7mNB5Dez1HxzZc6KjP8bslYJ9xpc7TNfmEjn8piSvmi3JsxvOlJss5e2
 lW3AOsuJnemAOCLKndWc/2Hrcy1e+eAo0s+7MmvaNPEB1aWiLPxadOEbifpL+bYffzF9SRoXf
 oQpWpw0USJkbVlX1mSVxnZivQf8WmoCj8ZqkCp/vXK3Z/vUfZWLuDEaNN6WRr0aySKkQ/WmOJ
 2I2R8RBoLEW4Pg6hOkyBee5Bw3iPdGS5F7pwj/obkZBN97mPM/qmqPQ9SV8ZtpOj7DLAKjjV1
 cmoi1LQY9OhUwGIcwS2CydEPKqhtvh1DRGdilFa7bJP5fErcfQsXEdaTktBRdPshCrVCwTpAp
 jGYL6X0vbFjm7aN07VELUP/br5tWwlKT1L734FwumHZHzmqM7VCPztjvERGRiva2+QHREQtug
 hNFXa7RtmD6fGGN60S6ukBZ4fbXpq2ovVf8uN3DKPMUHlRbgptXQXjQRw==
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

5.18.2-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 36)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de

Ronald

