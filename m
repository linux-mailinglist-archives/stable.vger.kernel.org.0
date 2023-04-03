Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9405E6D4B4A
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 17:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbjDCPB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 11:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbjDCPB2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 11:01:28 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861686A79
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 08:01:27 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id n1so14737886ili.10
        for <stable@vger.kernel.org>; Mon, 03 Apr 2023 08:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1680534087; x=1683126087;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ffPe1No83w+bTtrzxnzAioTYYfDrcjWussKBZp7m6Ck=;
        b=ICvNTRbe5vTBya87CVNVN8vlmBcyJz7KD9XuT66LLtRcik5bXvw2MKqQnHqTnM1Eg2
         IvsiWLbuYFfAZ35GO8o6bnQCdAq7KfMRSghSAsijqVgqJxVAcuvSllGVVQZlXIpxB8n7
         wNrslztvE2AayYqurpPcAhB1fcviyOgHO7UnD3WEcJrGzAFHFyV92XsKFikMrAMG8n2O
         oubrrQF8o2jHk48c99Opx80WKAoyF+ReLUvUH9seM3znxfb9zfx2iALGIFAFpNGytxJO
         SXYRbHJBIuHaugdJbJcWsd0/iTR9XC17gZJK0EzkwfhfUcfAvSiOZqxrY6o7UuVxWmum
         Ljow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680534087; x=1683126087;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ffPe1No83w+bTtrzxnzAioTYYfDrcjWussKBZp7m6Ck=;
        b=L93f4nqVdmIeUzh3aYJFqIhE351QppqNNaJHzrKiKKc9V3X45+5MWcxTCiMt9N2eEj
         tyvTEB6ufXWl3Wui4oPWz+tdGq19+/lvw1Z+rCleOXMgbAf3IoY6zxQTlaDSxeR43tmS
         5qNPT/0NEbmHFFUO5boqD3bWB6riTvH+kCyLn8DJtj/R3vrYL9o0K8iaswPM9Df40b9o
         iVRrQE2yB3POhywx8RsiA1H9sAH8sKo02GeZ4EeEw5ZQDuttZLiH5SR6DYlIBd7PATbK
         clLg+2vftcF7CyzDzSFW1Cw3mN0bq78zYYpL2D8owqe/OMryg5IXAlNipKKHFhkixxHd
         MmdA==
X-Gm-Message-State: AAQBX9ecZZQt6BewKx4fCwg/R++HZVazR2oPRqIjsHnyi6GrLM+BULl1
        lAnjr6Xy7cBrm0Ywj7VQ2eziAw==
X-Google-Smtp-Source: AKy350bj83ysOItF7GySONiW8wm8gkOT4i/uy28roH7PIamDd5X2vSHS+p2pfgeyX5Ud7sYqhQwF7Q==
X-Received: by 2002:a05:6e02:13e2:b0:313:fb1b:2f86 with SMTP id w2-20020a056e0213e200b00313fb1b2f86mr7325430ilj.0.1680534086843;
        Mon, 03 Apr 2023 08:01:26 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id m3-20020a927103000000b0030314a7f039sm2605822ilc.10.2023.04.03.08.01.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 08:01:26 -0700 (PDT)
Message-ID: <27b87281-1341-f044-cf94-85083c2b090b@kernel.dk>
Date:   Mon, 3 Apr 2023 09:01:25 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: FAILED: patch "[PATCH] io_uring/poll: clear single/double poll
 flags on poll arming" failed to apply to 5.10-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, pengfei.xu@intel.com
Cc:     stable@vger.kernel.org
References: <2023040352-overbuilt-backshift-9c74@gregkh>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2023040352-overbuilt-backshift-9c74@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/3/23 2:18 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

After reviewing 5.10/15-stable, I don't think we need this patch
there. You can drop those two, thanks.

-- 
Jens Axboe


