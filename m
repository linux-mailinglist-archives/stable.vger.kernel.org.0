Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541BF5F561A
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 16:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiJEOFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 10:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiJEOFy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 10:05:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A17C7694E;
        Wed,  5 Oct 2022 07:05:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F9EE61704;
        Wed,  5 Oct 2022 14:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3835BC433D6;
        Wed,  5 Oct 2022 14:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664978752;
        bh=scXS6ZhuTh6xsx3fuPeKlfJsKJMflXIWX7c/5vBO7rc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=tUEzgRJ2Cz2WJQ+vuAcgPUtSb7WJfJm4OzjqWnQryTFCvGD0+PEnzdCgrbVCrPxoI
         YX+bGL6vvFJ96s0xDKNg75/TdpiZFVfR8ARHXiOnIjhHcx/yR9GSRss2VdwB3t5HcT
         8mj+RhmfrdDLo8sWIDbQpk2IxiRHb9zNBeZj1mMpvHXCC1YmPAdWnynZsLp5HPFZoU
         C4waj+CExbURHkQyN+ULXE00itcKcGsPy4sRIxFOkEK37cQ4BF0SKBkMZbhy64HLx4
         rM5cZLyqq0TlNLvPgLLX270yJs49E5nB9rPfzQgTIkzz32m5UtmytT1lxwji+Khb3K
         g5lnZk64uPDfw==
Message-ID: <40bf2957-8134-a30a-fa2b-8f6593692c24@kernel.org>
Date:   Wed, 5 Oct 2022 22:05:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [f2fs-dev] [PATCH] f2fs: allow direct read for zoned device
Content-Language: en-US
To:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     stable@vger.kernel.org
References: <20220930225342.1057276-1-jaegeuk@kernel.org>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <20220930225342.1057276-1-jaegeuk@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022/10/1 6:53, Jaegeuk Kim wrote:
> This reverts dbf8e63f48af ("f2fs: remove device type check for direct IO"),
> and apply the below first version, since it contributed out-of-order DIO writes.
> 
> For zoned devices, f2fs forbids direct IO and forces buffered IO
> to serialize write IOs. However, the constraint does not apply to
> read IOs.
> 
> Cc: stable@vger.kernel.org
> Fixes: dbf8e63f48af ("f2fs: remove device type check for direct IO")
> Signed-off-by: Eunhee Rho <eunhee83.rho@samsung.com>
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
