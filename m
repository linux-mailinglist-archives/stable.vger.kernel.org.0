Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAC643B4D0
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 16:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbhJZOy0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 10:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbhJZOyZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 10:54:25 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD343C061745
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 07:52:01 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id n11so10506513plf.4
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 07:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=G3LvPAmSdRoyBQAYSA/F6g6PZN2spKkcG9eODDq9JOM=;
        b=dKn67dLY5rM67pRHNIbDdTjm4adEctqj03GxQ9FtUoHsggo3M9NkfW7kgmiPKEa5cr
         hbGsSmHsI/iz6tpN7FqssGJn4XEPPq8FXGBAIxdVPRH/kvYoRN3SX+H5rNcGd3YtiyW/
         ExoLyuCmgZ0nOQOgxf7+eUbqFjCJTJv0O8upbqMTd2TmdXcpMqDZLNx0VlN1jvPc7QzW
         SMIWkalCBifZxyDiE2KPMHQs3Okv5SNeFbCNt4hlymQYvN1oijLnxEMy71qoNGAXswbz
         luo4KDtVxd0MyXn64LQA9/GZi77qs9fHP81wRA5xMy0q17tMc+m2wxM/C+9GZfm5sSkA
         sJ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=G3LvPAmSdRoyBQAYSA/F6g6PZN2spKkcG9eODDq9JOM=;
        b=8BPbBPgUT7hXbKkn9HCPcsj7Uxr8jHOcuVb5G+Q+amgmofT3k5p+Qmv5qSgUqDhSd9
         LzkmooIBdqAA68NazdR600j9z4bZlKhrYVklSZxCE/qVNiZ+tuWVUL+UCciFfYRj3yKd
         fiSPrufDEbnwCJFNzFroB1hYHBuh3aJiKBWOWI38SWCC0fWgwudTkwCK4RrS9Jwu9Hul
         NP8tg0GSxo18+GgigQ7HVABk/yRpx2m5fYqZFgBSlBlBa4XTVrIO/wEJ9MNiziL8K8At
         za2nC472vXEl5/t9o0j/NImY95PhmhWgq8OWbf9sVrAtfTvVKrJuPrCq2FRzBzAUupDv
         YsuQ==
X-Gm-Message-State: AOAM531WUOjeGvp8kyg5T6Ul0xZ85ejtW7517s35nZ2A7vWVABBumhd4
        d5KZgMD6UBuk+av8KP2an5aQQg==
X-Google-Smtp-Source: ABdhPJx1jYrZl0kmCBFVPFfbhpPlqVGyEp9RKHv/Ow/lXprZx+4/9FOpMDrBT+l+E7UT7HWKGhWXXA==
X-Received: by 2002:a17:90b:1b11:: with SMTP id nu17mr41438225pjb.129.1635259921198;
        Tue, 26 Oct 2021 07:52:01 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id ei4sm795279pjb.56.2021.10.26.07.52.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 07:52:00 -0700 (PDT)
Message-ID: <68be83ab-c0b1-78f7-0234-8e915339d570@linaro.org>
Date:   Tue, 26 Oct 2021 07:52:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <e3ae5f6e-1e96-9d7e-c126-6b4fb00f83a0@linaro.org>
 <YXeVmDtzkC1sUBCv@kroah.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH] usbnet: sanity check for maxpacket
In-Reply-To: <YXeVmDtzkC1sUBCv@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/25/21 22:43, Greg KH wrote:
>> It should be applied to stable kernels: 5.14, 5.10, 5.4, 4.19, 4.14, 4.9, 4.4
> It's already in the latest stable -rc releases, do you not see it there?

I haven't checked the rc releases, just the latest stable versions.
Now I also see Sasha Levin's submissions on the stable mailing list archive.
All good. Sorry for the noise.

-- 
Thanks,
Tadeusz
