Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C711158D01F
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 00:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244372AbiHHW2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 18:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbiHHW2P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 18:28:15 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66335186F9;
        Mon,  8 Aug 2022 15:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1659997691;
        bh=+nGysjs6lsmco9qhFme7ZpGFthTp3UK3NfNh9+tqI6E=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=S05efhuD6F9KKOWpaYoxsR7/qzOYykYNnFEqEGd5fD8CkPLhgjs3wrilCJSEYHklS
         JrYFZaCns4MeQ05qHEPHhC8W+8Ati6TqDhAUslmV5jKr99K9OLtjsgnWFeeRyWs4Mt
         fqvBlU3H7qhyRb4cPFvs4vqWvqSzHnz4FD4EFwxc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MS3il-1nxLsH1uln-00TVct; Tue, 09
 Aug 2022 00:28:11 +0200
Message-ID: <02c30c99-b469-7b55-ddf2-7cff177e40ce@gmx.com>
Date:   Tue, 9 Aug 2022 06:28:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH STABLE 4.9 5.4 0/2] btrfs: raid56 backports to reduce
 destructive RMW
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>, Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <cover.1659599526.git.wqu@suse.com> <YvETDmzlSBMpObNm@kroah.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <YvETDmzlSBMpObNm@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:YcMb61aXuu5/rumD1gzSRUIEaRulM8l1JFZn0I+DnRyO63MmgdA
 EI+pRPSDW8hHSsPVp5pWBzeem7wnqDsVwu44ZDhnqn73cm6GRKdLpoYnvvt8p0WVYboYKLh
 LrG/tRmHA7qvc5ujA0HjMDUOEJjVLr967wRMINQxsy9eY73MuPSobkqF1J8sjDFqM7OVeOX
 IkPfOoJYjPG4rkyVOUnTw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:IJfGX3QwkmA=:F/uFmVsEisptgkx1Qiodga
 s647MxckLXqtLt7ttFDMpVX86/Dzhg0VJFV2mov3RjIr1T+cRijrDHDDofw4pU2+asj/xpxOw
 tNfzbmb55U6Rzj9HZHthzRuRGaD4YkHHgRDpiEj1YCv+MTypbXfcw1pBSxp0AmG6Wm000y1IY
 NWdJrQHiYm1TcZCJ68n8aXkRp76ECU57um33cDf9yWH5bMEsmpezR+b9zRD8Ceyjw/62N0Ba2
 maZNPzBzUAOSTG48blbKVMTMt/VtwxeuSpqvszz0EK0VGfeDexrZRISNNOWPTKvK+VbPlR1uY
 177A0Qyy4pgLdvT3h8B+3jtM6LfdXus3pRZGc2XxUovVkUBIbsuhYJrDJaKORCvEQ1ZpTFlLz
 YpVqbs9NKe30CNk+AEf+wlCewPSdWI7j1fMwQOyz1oDsVKOG3hptp0+B92C31nyi/YX4dYzOu
 8SisTjKs67ka5FBOJrPbCwRN66/yMDezExT65iox3/VFoWx4mOejv2P3A2nGRHJcWz/YaYkZv
 1LFoHd6rglHGf6Wt0+rUUaLadnSmttwhm0nJZprZK4fC8Fq5bWedAniVomNFiTu/EKZBM2YYF
 QlqO66LcdjmU1dlbumMbQ/VikN4qxTypNLz2KCNbbMUrrVh20St53UZe2TrxzA0DGjOAa8VDC
 9BYNSJeylpF0nLdDDX6DfOW8y03D1HXjMx02NlrstSe5+shWqofKkZBjviB5IwvGNQ56iF0BU
 VAiNHrczljVZbad+LTiHzmvhrcmyzGvijJsRbu1j3bwfYCBrzMd2t6fqHS7EHUZX1F9gAWqQI
 /uaGnVR83k3/Rq+0m3CI8GtmthopPSAt/9NsU+q+vGaKQCFnRqHsUnJRpaSIuTJhczOEss0Le
 CE//IZTxhbxYKa9Zi/FAXIiNDGCfIFSe5xa27mkYtMDqX3wJiMKP5RfxH+tezOeybDyv18gOd
 BULsCaRkN+nGuGh4TSWmrz5up5gvnk2EamCJp0pCQzPBaaok31WjSkmwjA3Qri05sAcdPbvjO
 FQPnShksxqPQueZE+M+AT1w62U7+HPTmyvOG1tP6eklAvlv4HY155mTRSy0+HcPtQrvqDbhOu
 zsv/2e+0sP7Rv7rCgvFDu6nCyIJIWuD2Kps8GFV4ojv/uv7faJ5SC4cSg==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/8/8 21:43, Greg KH wrote:
> On Thu, Aug 04, 2022 at 03:54:17PM +0800, Qu Wenruo wrote:
>> Hi Greg and Sasha,
>>
>> This two patches are backports for stable branchs from v4.9 to v5.4.
>
> Please note that these commits are not even in a public release from
> Linus yet, so I would need a LOT of assurance from the BTRFS maintainers
> that they are all allowed to be taken now as that goes against the
> normal development cycle here.

Does this mean, normally backports only happen after a full release, not
just after -rc releases?

Thanks,
Qu
>
> thanks,
>
> greg k-h
