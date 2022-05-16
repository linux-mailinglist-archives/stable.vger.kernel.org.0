Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A81A52804B
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 10:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbiEPI54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 04:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242601AbiEPI5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 04:57:37 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [46.235.227.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F82B17051;
        Mon, 16 May 2022 01:57:35 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: kholk11)
        with ESMTPSA id B13A51F42AE6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1652691453;
        bh=l0QO0e3OAmEaC6htl1tHIY5wK0hNU5w7G9YZ9DW0J/s=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=H3FuwrMGB5Ndq+tfShaySPLyKvzhi69sZ7n2D36ZHbkOBonmm0FfD6KKdEEZXqJMK
         nyTJmEw4UE5kFBihIY/StmX7fHnSS6W9/iXBLBEH/gcJY2vgSD7IpRnJg6KTUt7lHV
         6oUeSgkzY4+Hi/hfXvLgngWggi/1Cn465/X4VtLLZVPwZ6FstZCxiQPlHSZTDbPxA6
         dxW6dQk3Ur0tpxUUdRIgWe6czXDK1on8oMfATKtW6j1V7ckEoU4FHJFOBx06NH8Cte
         SiZgjWZhpPOFLUps9hdr9sqOVlRkHeEYB1UBEEMhQipNim3Wf8UIEVtvI5JgBEhYUk
         MqDkW/NW3SaYQ==
Message-ID: <20b50545-0a0b-b59c-83c1-0e76fe9694c3@collabora.com>
Date:   Mon, 16 May 2022 10:57:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: Patch "serial: 8250_mtk: Make sure to select the right
 FEATURE_SEL" has been added to the 5.17-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org
Cc:     stable-commits@vger.kernel.org, stable@vger.kernel.org
References: <165268940760187@kroah.com>
From:   AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
In-Reply-To: <165268940760187@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Il 16/05/22 10:23, gregkh@linuxfoundation.org ha scritto:
> 
> This is a note to let you know that I've just added the patch titled
> 
>      serial: 8250_mtk: Make sure to select the right FEATURE_SEL
> 
> to the 5.17-stable tree which can be found at:
>      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>       serial-8250_mtk-make-sure-to-select-the-right-feature_sel.patch
> and it can be found in the queue-5.17 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
> 

Hello,

please do *not* backport this FEATURE_SEL patch, issues have been found with
that one and a revert has also been sent:

https://patchwork.kernel.org/project/linux-mediatek/patch/20220510122620.150342-1-angelogioacchino.delregno@collabora.com/

Regards,
Angelo
