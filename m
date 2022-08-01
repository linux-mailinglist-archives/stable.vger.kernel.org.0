Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7FB55872B7
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 23:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbiHAVDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 17:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233686AbiHAVDS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 17:03:18 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A8237FA4
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 14:03:17 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id s5-20020a17090a13c500b001f4da9ffe5fso6399180pjf.5
        for <stable@vger.kernel.org>; Mon, 01 Aug 2022 14:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IH7SUfAFawEEqDDR/Aw5tQ7kushbt7XtMM4gT+NXNyE=;
        b=ZqWLj0OJYNRUPXxVC6tj6GSJir/W9NHOYUWYgPta6uWM5OUo3xUH3OMz/hIVEv8cVT
         qsOuyT+JOIxVIDjV8Fc5pjumpWpknL3Yj1WbsQeGX/VozqV02Si2I5giH0Ej3nAB5x/J
         d6gQon7IAkYeaIXRSiNWRIk9GzvpNQnXNRNvIKp7bYo2aCbVSFqbOQnws0u3QuiFhraI
         77Xg6zPxAf1/3IyIq9Hgwo7LmaBi4Mf6ZB1OkJTi0tVOPUUR8fBYVsJW6xIpr9qK9aII
         Cf1VVSp6+u9RiPxv+GlJ+5HoiscnD1Q7DE73eV+jfPgr1pCYkUelPffs8vYv0F+HAAqq
         PNJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IH7SUfAFawEEqDDR/Aw5tQ7kushbt7XtMM4gT+NXNyE=;
        b=yzYFR7golj3ezIMjumDw+ql2ga8PLO0+/Pbo/KQw7xRZde/h9I2s1wp74tiuq673Wt
         JAFfEFMWfyzefAdZD5WY8eLsy8zZIm7N0ToLjQGCkRndCXiWKtuSERRNnGkbPrkNXzil
         AiP+L2Mc6Z/FxDvG29Kpy+JIFWtB/aYNvAUsQZEixxYYvLnkaqgjBrgOmOuGosXrli1j
         owU01j0OdxU2P4Wk9s4AvABu4oXUUD2DDu1M5AZplLp4bvHH8tWR8bzxsIxtd09h0y5Q
         NwLz2n6ZWHY3h/Ytd/8nbAgcNemPokMZKsmtX4vpzwSor+haT58Tya5Pr5EzJi/5F/Qz
         ZSuA==
X-Gm-Message-State: ACgBeo2bMiDGXHSLxUnqa5CoQiucxbDX54TRftlJcq1k7KpSW+2TmtKs
        HrZyDBpHXl/wFirgmmc3J7+ZCe2l6Cg=
X-Google-Smtp-Source: AA6agR4sQ6JAK1dNHtj7pqMlrTu5Dgz5BdeMGIpIYvOHQSV2SA/MWb/Eho85tRPq1YESB7Om2t0jig==
X-Received: by 2002:a17:90a:1048:b0:1f3:e9b:2ab4 with SMTP id y8-20020a17090a104800b001f30e9b2ab4mr21479929pjd.106.1659387797396;
        Mon, 01 Aug 2022 14:03:17 -0700 (PDT)
Received: from [10.69.47.244] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p1-20020a654901000000b0041ab5647a0dsm8044735pgs.41.2022.08.01.14.03.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Aug 2022 14:03:17 -0700 (PDT)
Message-ID: <0b5001ed-050f-f5d0-72ee-3cc2ffc7f9b8@gmail.com>
Date:   Mon, 1 Aug 2022 14:03:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH] Revert "nvme-fc: fold t fc_update_appid into
 fc_appid_store"
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, "Ewan D. Milne" <emilne@redhat.com>
Cc:     linux-nvme@lists.infradead.org, muneendra.kumar@broadcom.com,
        james.smart@broadcom.com, stable@vger.kernel.org
References: <20220801162713.17324-1-emilne@redhat.com>
 <20220801182714.GA17613@lst.de>
From:   James Smart <jsmart2021@gmail.com>
In-Reply-To: <20220801182714.GA17613@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/1/2022 11:27 AM, Christoph Hellwig wrote:
> On Mon, Aug 01, 2022 at 12:27:13PM -0400, Ewan D. Milne wrote:
>> This reverts commit c814153c83a892dfd42026eaa661ae2c1f298792.
>>
>> The commit c814153c83a8 "nvme-fc: fold t fc_update_appid into fc_appid_store"
>> changed the userspace interface, because the code that decrements "count"
>> to remove a trailing '\n' in the parsing results in the decremented value being
>> incorrectly be returned from the sysfs write.  Fix this by revering the commit.
> 
> Wouldn't something like the patch below be much simpler and cleaner:
> 
> 
> diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
> index 9987797620b6d..e24ab688f00d5 100644
> --- a/drivers/nvme/host/fc.c
> +++ b/drivers/nvme/host/fc.c
> @@ -3878,6 +3878,7 @@ static int fc_parse_cgrpid(const char *buf, u64 *id)
>   static ssize_t fc_appid_store(struct device *dev,
>   		struct device_attribute *attr, const char *buf, size_t count)
>   {
> +	size_t orig_count = count;
>   	u64 cgrp_id;
>   	int appid_len = 0;
>   	int cgrpid_len = 0;
> @@ -3902,7 +3903,7 @@ static ssize_t fc_appid_store(struct device *dev,
>   	ret = blkcg_set_fc_appid(app_id, cgrp_id, sizeof(app_id));
>   	if (ret < 0)
>   		return ret;
> -	return count;
> +	return orig_count;
>   }
>   static DEVICE_ATTR(appid_store, 0200, NULL, fc_appid_store);
>   #endif /* CONFIG_BLK_CGROUP_FC_APPID */
> 

Reviewed-by: James Smart <jsmart2021@gmail.com>

looks good on my end.

-- james
