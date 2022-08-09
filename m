Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E7E58D38C
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 08:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236184AbiHIGIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 02:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236105AbiHIGIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 02:08:43 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A372B175B8;
        Mon,  8 Aug 2022 23:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1660025318;
        bh=VICc5DrFt18X3z+gEzpINNYKxcHCMhRT7GSUG9lpu/s=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=auzsO1RV0Vqr8O7qdNTk0pDqVfmWum0Ls3wqe7flqSjw2deOTZR9UFZN8NRSBd4xD
         HsSvV8/hs+pmOINbnqbyel2Nc4PiUM5L3wUT9CYoE6CQWIpReeln6RMcSAbFGyENnV
         VMs0YG6VFFSmpKEs3sW2nQwSo4J3TmkiJ3b9ZEIE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1M4s51-1oMfze0CBj-001vMK; Tue, 09
 Aug 2022 08:08:38 +0200
Message-ID: <a2d95460-af6b-f397-5019-ab09242f944e@gmx.com>
Date:   Tue, 9 Aug 2022 14:08:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH STABLE 4.9 5.4 0/2] btrfs: raid56 backports to reduce
 destructive RMW
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org
References: <cover.1659599526.git.wqu@suse.com> <YvETDmzlSBMpObNm@kroah.com>
 <02c30c99-b469-7b55-ddf2-7cff177e40ce@gmx.com> <YvH1cU3XZLI093KZ@kroah.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <YvH1cU3XZLI093KZ@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:OHX6z2EbjO7fdSSM7zO18IsjMRKzVl7PdsMo6GpILzaA0QmKk4x
 wHqDqJVfG7d6Uks013u2aL7EKmgQO1vht5Rn8kqTDHmnBwfTqfg6ua7COoAElenEVmOaNFB
 CfcOHOE9tII7PeYeintQs1SoUexalrteVc+o9rTaTW6tJXMBkHF0Y9qovR1ZwWTtTvyqEjx
 IR824M7sSBCGBIbetOVMQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:1eGTvTQvlq0=:oOKJVRQkwSui4NxHQu+IIJ
 0XO6uMt0xjtKosnWZY8/IKqG/lDdKRG7bU/z/LkLRBgnG6n+KFG7Cqa7krRpWZ0bNlHjrOahG
 imBOYlQL+zUZTSSmIGIBpIJfoLYyix+0nJ49txIFtrEf76F6hxFu+Qwp34sdg/fvQaEkoxKBE
 7hGiCTGx3qObbRqE6CH8IQDFXcY+xnELIHzNKNYxKQmKhn76ZJIH3wQ5qOjkg5C7Hy4w8kQcb
 X4ac3+R7y60xYOJumR9gsA9ke9l/7NKYoNI9sgXe8pI0J2ISl5ZMqmNRo4g7xZdD9ay3bEy9p
 aRe3UWwea/ut/EmFdfPrlEo2Vp93MxRQg/Uz7MP+xZjG2QKzHQRgJOV60nY6wnx7v7HiUj/Vz
 nfBHdkig35X0ZU65jXj+mhA49cK3TxHIR9v/45AzyEfLDgNQ8C9lV+rCCggdTROziLpT4ycpW
 apVMLBO51zNC4Z90EJGBVFNU+tnQsdSxx9YCl2xeocztUDV9nCke7KFnzDbtmVBePoiv5b7Zn
 3dEVxQ7QbFiYlWGVFRQlbTxlkJpYSOkjP9nATKqIvLRaEPutZKm80ZO2TSpuxfz6Z83gnp0y0
 GYUP1yPDABsS3Ipmp06+4rqbt6EG/ekIXDY3iz4C2fG8qRHzYOVdToEuq/0EwkI62h1ceoQyP
 eb7mUkDxqS76WiKEBNmSNlI4bbTjNMiYSaMksEqjk0SDczmxSWNPIsAbuw7R73ClAcF2VOGX9
 WpEylAUWRCjoWKprBnxTS0YUMj6gONCtX2RSU8NBj0/WfFHSfL9kp+gQUlK3t37hE0kXBbqAT
 WIXW/ZX6RYile6Ns46nIukoh/lMregWuam4JNbWnihC8/Q1KqTBwWCzspvN8Z40VmT1pPdTSN
 7/vDuXKONZqolTeKvzK3v1N5oEhOw68le2ix3xOwi4BmdxANvY2QkJwdtWYfGmL8zVy6Obd3e
 1TAYC0v7Q3A83DoHeNBkEa62wwfQByNTwVagGp7mYayMlWL/AkH8wug9Lw3gtc2QQNw+9G1t/
 ef8v8l38Vq+fwVCc9QP5Z3p5WP2RYDEcA0fxzXtcJuu4Lgwkl7EOQeinE2Pf2WSuC6FRtSA39
 LVBl0ykcZVXV08c9BhgaYC52TD5Abvnl22Q4ocK404+3tSKIFHQMB/Y3g==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/8/9 13:49, Greg KH wrote:
> On Tue, Aug 09, 2022 at 06:28:06AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2022/8/8 21:43, Greg KH wrote:
>>> On Thu, Aug 04, 2022 at 03:54:17PM +0800, Qu Wenruo wrote:
>>>> Hi Greg and Sasha,
>>>>
>>>> This two patches are backports for stable branchs from v4.9 to v5.4.
>>>
>>> Please note that these commits are not even in a public release from
>>> Linus yet, so I would need a LOT of assurance from the BTRFS maintaine=
rs
>>> that they are all allowed to be taken now as that goes against the
>>> normal development cycle here.
>>
>> Does this mean, normally backports only happen after a full release, no=
t
>> just after -rc releases?
>
> After a -rc release.

Got it, will wait for the -rc release, and meanwhile prepare a v5.19
backport too.

Thanks,
QU
