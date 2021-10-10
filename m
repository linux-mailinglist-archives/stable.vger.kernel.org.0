Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B51542840A
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 00:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbhJJWUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Oct 2021 18:20:50 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:42697 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbhJJWUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Oct 2021 18:20:49 -0400
Received: by mail-pg1-f181.google.com with SMTP id 66so8965578pgc.9
        for <stable@vger.kernel.org>; Sun, 10 Oct 2021 15:18:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kYrjvDUA+4jzQgkLGa35lZNmfTO/gng7Xw9HaIfCRQA=;
        b=NcbwCmj3pU8z4eHzxKdORvpj7mE/Ybuea5d5pF9364w5TVAXkWtNWm1YFhNRAxZ2RK
         vjdQ2wKgCBo/hSNSEJXKwIP9IOAddPa3RRM38WuVhHUQ+tcUDJecBqdSBla3IRJ5tumf
         3DjGBIPJIxbg92XT9BjtwtdLi1Yq7qAzSQlQ6lV+fSxDMnDzCvtJ+X46fTmylIE60bye
         38/iqd7ZqJ4JCItl1lScbvDyCOispg38xfZqdWcv1bZlJ0mwWOkLF7kqCjGAbglGL4cJ
         Eq8FmayDhfTrr8iWBVoStX6LqjLx2NPUapyokBk5SAifvZZBbFNRbl1JFMpB6WzpqbdC
         ZRXw==
X-Gm-Message-State: AOAM530U/yA1bG17qi0dixCZ4TdWdbK0wiFuNCByG6OuPSYYQTvHsEfs
        T+eLHRUz979JacgKwp9eiNCnm+2ZRZc=
X-Google-Smtp-Source: ABdhPJyYn1baryGGAKTqRESmEx/BYm2fWs1vntqyUEbfI9ia632sA4G/mAHR2SxfhCc6Gl8y/MgEpg==
X-Received: by 2002:a63:ab06:: with SMTP id p6mr15447612pgf.112.1633904329770;
        Sun, 10 Oct 2021 15:18:49 -0700 (PDT)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id w125sm5448586pfc.66.2021.10.10.15.18.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Oct 2021 15:18:49 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] scsi: ufs: core: Fix task management
 completion" failed to apply to 5.4-stable tree
To:     adrian.hunter@intel.com
Cc:     gregkh@linuxfoundation.org, martin.petersen@oracle.com,
        stable@vger.kernel.org
References: <16338612988264@kroah.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <87f18324-fb70-0e4d-1af9-2295a71aa75f@acm.org>
Date:   Sun, 10 Oct 2021 15:18:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <16338612988264@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/10/21 3:21 AM, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Hi Adrian,

Please let me know if you don't have the time to work on this yourself.

Thanks,

Bart.
