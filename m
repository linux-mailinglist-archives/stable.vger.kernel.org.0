Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6D2C6D7B3D
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 13:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237249AbjDEL0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 07:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236486AbjDEL0t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 07:26:49 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A378DE47;
        Wed,  5 Apr 2023 04:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1680694006; i=rwarsow@gmx.de;
        bh=jaDUDIRmHSb4uoijvQ3c4ZPynBSillSIn+Znqbt/15Y=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=mdA2kkmm562xaZQa2rMmORA0Nl5sxxdlcaYb6yXPCVdj0Qj0tcgeXTi4p9lL04SUr
         YK9x/xs07MEr72Ohj4QbjXdCnglA28yLSw1Wu8lpw6aLjR40/3g7eDy/jEQgkbRiEH
         y2NHd4fvm6VXMELLsx/Pw0+s+9WwyPSYe8Bcy4WFlGJ9jx8SYABlCHrdZpd+EWOoz0
         oV3KaGR1Za4hSzkL0daWrn72HOYk4SdEUc9wEkXSkZ4CeBTGb/rl337a5v0HpqVVuB
         Xq3i2+KfT19YA+9rDKvVFbahX7SNjIW6O+LSfZEK9FmjerQbGwR5X32fCbwzQGuAV5
         Sq63yubIwOBRA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.32.226]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MD9XF-1payrU3pcv-0098t7; Wed, 05
 Apr 2023 13:26:45 +0200
Message-ID: <ef8a9c50-9914-3a9a-ced3-3cbaa475758e@gmx.de>
Date:   Wed, 5 Apr 2023 13:26:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.2 000/185] 6.2.10-rc2 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:nLIn7C1u6LUL8y8lf8LwzUikn303lY+0D8biSkJuePwYhYXEgal
 KC9FdAM5XQt3qkNX047RCQ5ocCAV8oqIg3M9+Nx9Kg7IbGZnD70CfDbhWUcNfnzgoAsxE4j
 BhmmQzUvdSGlNhVBNZeVmZ0qlA/253vcxvLoxuv41166ifhu4YpA7xK2hAJMi8OxmHkIuVu
 izLXtCYqERhNH9l4O5hyA==
UI-OutboundReport: notjunk:1;M01:P0:sqsq85RIjf8=;m25pPahKfQA4X1p8sP9f9WtKPGu
 goUVwzfzUJ6LEwnnQu4GwbYwUWI7fbn4alxuu8nVON/3bYCNF5510J3TVfZwNNmqEuzogmQHi
 7VcjZfAJumURpd3Xoo/Wt7x6tXA/Kdcws5zNYqi+QEmQn5LGjl8yKiSIU1uRLbuM+ZRSVCX2y
 lmyv8YJ8hnyUUc9gGR2Oun/nSk/RK6jDcdJPpYlIkk1WEEbMSY3Nj6icaIUagrv9O5bXuWO5d
 kLHFkJbgrdxL/Jx1G9kfHdj8P81iARqG/woNdUEyByyzbaXqT5gPmRmiYYVQ367mVqDjNhhjC
 FcKy1sI1JCEHdn/i6yEr26S36TxTe2HfQBpTeb2ev2LoTkUCFBC0yULFfRRwE2OytJUy18183
 /iR/Qi/N0RS7vSSejoqnSBGMlpw51a2Z6pHlf+SoJ5yIIFKyNhjnMGng7sRf8yFsYmwKNxwN4
 4AzzV4pYorC0Nqhu8o+jajH/cUrFZdDqOJs/FqhHd7+tyAz4tYpEnE1kkab/87L6jNfUOskGg
 Y1o2jjFlR0/5CnkFAFC5sIAWoKtZdQHtQ7rHZju2ap067ooMck6K56a0h5NESgn/8AvhuACtC
 IL2W5gNN3SY2HhoFQTRBBDRXzPwlpfHdLFBR/dRmuiGNTWnqPAHW3M1+M8afibNI1M+qSYV6w
 zcEVyozrq/4z4mEoqldhOKIn8wskfuDXqQZlZONesujJTUb9PTzzGCoROAhTUREGZw/BJ0EPR
 R/kinVvpajSwGiCCgkK6Ze/eMm68C6+shqsLwZJ2jPEFugFEe3MzNI04fnApE1LKhlZPBogEy
 JpQDqGnp2AZjmi/8B02C9IPMvtJCo7OjeHP6oCBhFFV1p3e2KTopxaBUYTobwyYUtWoC6WJX5
 p+sXi2DGrBcL8xNzfDJVAcEI/v959V/VhypNt+22jLWDh5F36VqDkSjzpSNr7A6Q5cW1u0OB4
 iiCqlM9DgoaDIwG5rw7K6cHFMTs=
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.2.10-rc2

compiles, boots and runs here on Intel x86_64

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

