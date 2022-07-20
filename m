Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7883557B899
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 16:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbiGTOgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 10:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiGTOgh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 10:36:37 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A56322298;
        Wed, 20 Jul 2022 07:36:36 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id l11so32366864ybu.13;
        Wed, 20 Jul 2022 07:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l2K7nEe+ZGihrGCPvkVejdepUpONqFjImeiilsYjckM=;
        b=JrOZjshdDxw5WjcjM8eJGGD2brE2alufdUXE2EYMRFdoQqMgSFSqFui8tOnwLp0mBz
         D7/GbI3yV0Gph/Gc0iu9QSdVm6aPG7fOq9TA3qAf1No62+vYdLFlqyI649KcJVZR46A2
         82oyH2Gn22ZysdrHGoJId15mNgTntyhzB6iSfIpeQfU2Tv24NFVhnnMLjAK8iEny/Hf5
         TKf+LWIwdXHgb6qpGPC4yzSc/+1W0AgqCetV0r80bTYxcEqjZcJ4/+lAmgxFgOWLNBgk
         Z/jTim8JGYoirmF4tVcEE9yJzdVAszj76HtXJQ7IEF9igeneSjyHW/shw2PajJwovzcU
         6kxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l2K7nEe+ZGihrGCPvkVejdepUpONqFjImeiilsYjckM=;
        b=4Lj6vZvoUYA6BjvGQzjU+OSKBof4BvJYoCpT7xBVmj9mKFa3Lpt3HeQSEq1eUo1JOe
         L53GCKtJCBQ16/e52oaCUcnoszaGRfvk7RFimj3ZjpPbWsfe/jDMXI5Zgsjie3kVFDTs
         JLFR/BssP2CFx3vxO0jlfk/QzkGchx0a3CQwcmNyRQaut25DO1fmbt8LJQ3CXtXaYtOC
         d8lI3tKJkXhXJ0icbfuB2kkobvc8KEagK9d9zkv4cr9UTE3f4GtYGTF8HTWZR0mR7FJl
         1B3luuYIxrmmU7cWEG4PIzf8ZZNQ43xhbjLPzHlur+0c6gnxvi73nA7Zmvx8woQmy1RZ
         AhWA==
X-Gm-Message-State: AJIora+zgg+Wbg4coLzfPsYBwbTAkw6Q5QTMZNeCUV+1pBuGdkxjXZd6
        xsbEVmlDjkZ0dMROh5IZsMqJZtg+N0bIg4oy8WMbrrMW
X-Google-Smtp-Source: AGRyM1uv9ZsVUdsc25sRKn8FvLi990DWDvzGdK7aHQBY2ii5SQpIeeFUumEPI4FsSBdgpEbhwDQNszA2N2roEFlB3Uo=
X-Received: by 2002:a25:e70e:0:b0:670:7fb9:e0dc with SMTP id
 e14-20020a25e70e000000b006707fb9e0dcmr8607816ybh.617.1658327795545; Wed, 20
 Jul 2022 07:36:35 -0700 (PDT)
MIME-Version: 1.0
References: <1ca489cc-491d-f78f-5743-fd47d6c98efb@gmx.de>
In-Reply-To: <1ca489cc-491d-f78f-5743-fd47d6c98efb@gmx.de>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Wed, 20 Jul 2022 15:35:59 +0100
Message-ID: <CADVatmNrb4fH8OLvrAtT0vjhZCYvcc9+OpQnjypuxHCtXqXd2Q@mail.gmail.com>
Subject: Re: [PATCH 5.18 000/231] 5.18.13-rc1 review
To:     Ronald Warsow <rwarsow@gmx.de>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 19, 2022 at 4:35 PM Ronald Warsow <rwarsow@gmx.de> wrote:
>
> hallo Greg
>
> 5.18.13-rc1
>
> compiles here with a lot of warnings on an x86_64
> (Intel i5-11400, Fedora 36)
>
> warnings all over the tree like this:
> ...
> arch/x86/crypto/twofish-x86_64-asm_64.o: warning: objtool:
> twofish_enc_blk()+0x7b2: 'naked' return found in RETPOLINE build
> arch/x86/crypto/twofish-x86_64-asm_64.o: warning: objtool:
> twofish_dec_blk()+0x7b2: 'naked' return found in RETPOLINE build
> ...
>
> patch was applied to an clean 5.18.12
>
> is it just me ?

No, I can see on my builds too.


-- 
Regards
Sudip
