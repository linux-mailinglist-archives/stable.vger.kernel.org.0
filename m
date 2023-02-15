Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D39EB697EA4
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 15:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjBOOpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 09:45:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbjBOOpy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 09:45:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87CD305C2;
        Wed, 15 Feb 2023 06:45:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AC26B81D06;
        Wed, 15 Feb 2023 14:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1839DC433EF;
        Wed, 15 Feb 2023 14:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676472350;
        bh=i7XJdYYy5Ec8OzUEFnRgUnGX3zdu+ChHpKa9KrxeWT8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=bKr6YjHORC8EsH9VafAjrlUiaCMJvXEsZ7Zl0Iz0hCCUyCqcC0BSR4LuXEOywhBls
         lUMSTDN3h8okUruhrmpzamMTKPjfG8SkNB0Zm7yqZRXE9JDnALbMfreC38+hNlgh41
         5LS03rOr52DNRqUBeclMssI/Iqc9XKpFP9qJQAvCGNNIJu9Yt9uqDEqvnJz1Lhnr56
         9wyCUomS4yeu07y+dQEzBvz5fh2x1Ep8TFkUoz6f+P9ErUsiH6Sm6gNwR/1xroXpvt
         AQEXQAyqA5AprLWMX2Jn5EDYSPkinz0k4hVBAll1fjauDrddiK/faakSpyFSj7j5dm
         JDwmGhLfPGZzQ==
Message-ID: <4eb60628-1546-1bcb-b71a-92368d7116eb@kernel.org>
Date:   Wed, 15 Feb 2023 22:45:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [f2fs-dev] [PATCH] f2fs: Revert "f2fs: truncate blocks in batch
 in __complete_revoke_list()"
Content-Language: en-US
To:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     stable@vger.kernel.org
References: <20230214235719.799831-1-jaegeuk@kernel.org>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <20230214235719.799831-1-jaegeuk@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023/2/15 7:57, Jaegeuk Kim wrote:
> We should not truncate replaced blocks, and were supposed to truncate the first
> part as well.
> 
> This reverts commit 78a99fe6254cad4be310cd84af39f6c46b668c72.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Oh, my bad, thanks for fixing this.

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
