Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C66026822EF
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 04:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjAaDke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 22:40:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjAaDkd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 22:40:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741B3166EC;
        Mon, 30 Jan 2023 19:40:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2767BB81983;
        Tue, 31 Jan 2023 03:40:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CE5C433EF;
        Tue, 31 Jan 2023 03:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675136429;
        bh=L2PPKM923+y7/eYTbfR//3FC74N9z7G/ocwdtowlJ08=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=X8QuLPz2WYQxsasqvLqfcWE6eaUksDpDdrCALfmQHGQn6DTm1ZiKsdwcCPhG+gx9j
         zufiGNGldUXAkHnInzew1YrNy8A412H44/nvVH9TRq7kP69QXV06CxHXb3NQjExCF/
         9cl9ISeZeBKCXaCD8BHpYn8fVDIJ7FW4xEvZOxaWs1crE3n4HpuS2KvePYuiTyd85k
         sdZTiGh/O/v9Njti2S09cCMaPE8dt+uPdXeB+QqCHCLVBDfRUYIMammv0MGyUEVskj
         pcr+aAVK07l08mK21XV2nem0877ql8ZI/rdJ6+AYhmuIA5pRvjLH1nwS+1q6qVIGjR
         G6IytFttAY8qQ==
Message-ID: <bf23cd40-34b4-de51-8dd7-c3d0ac1f4a94@kernel.org>
Date:   Tue, 31 Jan 2023 11:40:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [f2fs-dev] [PATCH v3] f2fs: retry to update the inode page given
 EIO
Content-Language: en-US
To:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     stable@vger.kernel.org
References: <20230105233908.1030651-1-jaegeuk@kernel.org>
 <Y74O+5SklijYqMU1@google.com> <Y9hTCtWLo9/PQnnN@google.com>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <Y9hTCtWLo9/PQnnN@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023/1/31 7:30, Jaegeuk Kim wrote:
> If the storage gives a corrupted node block due to short power failure and
> reset, f2fs stops the entire operations by setting the checkpoint failure flag.
> 
> Let's give more chances to live by re-issuing IOs for a while in such critical
> path.
> 
> Cc: stable@vger.kernel.org
> Suggested-by: Randall Huang <huangrandall@google.com>
> Suggested-by: Chao Yu <chao@kernel.org>
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
