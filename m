Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801C320314B
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 10:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgFVIDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 04:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgFVIDs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 04:03:48 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFFFC061794
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 01:03:48 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g10so13902962wmh.4
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 01:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ywxvkE6q0cbrbXTJPKV3+AgmecGjcEiMLhxzggDoG6o=;
        b=B05aJafbS6ANDvwzCVLuomo34ddofnlUEe/dzFaae8H9n6l2rKJI6IrZm/zCfUTcG4
         OCLkNzJtVemG5dLrAysL/t/jVfGhLyhQTy382vmEjbizP4S+UajTShxqcx/D3Ekis/sx
         xjlHvyulEEeWN0OSkG4fYkV3K3HMQaRIBA0DdfA8Kz931INPhBaszFpcn02RhVs+MHbT
         UejiUNIdu5uDqXrb0p/vZjjA1o51htumX5Jv2W2cDFrlcJUf6NNfdCjp1NGj6emOae9i
         q4hwpXDA6BEg0uXpq9feIG9z6QgYtR0NfoQn0C5RgzJRgi4p8FemcfwKSmYpVKug8pAe
         Ky5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ywxvkE6q0cbrbXTJPKV3+AgmecGjcEiMLhxzggDoG6o=;
        b=da9VITpCHsQeaVlsy0mwmeHZAnmwAcxBNaG7lLisz6qmLxS4mqyFMd8D9qKGHjQxp5
         KSYSDEvVMJBTEWCFC1MeFNB6fHQvJIA9NhcQMQ5AWcTjJVgwCJkytK2aB0MkLLVGkwrs
         RLxa1nDgQ/+W4b02v5QRCYyAynfkwahQV6Z3Qqx67XAgvNbLzDq8AqZEpqeX5gyfAjI1
         bdAIaARJQQMCp+qBRPv81hJ21gR0/A4yFOJJSytsEGg4sQY/1tnD7I7pkRJHeY57FVAl
         chtoygVG+MsvlI6WFyZTZZ4nDlAI2t3lJvpUeJy+ZaHVs7Tk4e1Rz5EUaZ9comTWVFEH
         5Ifw==
X-Gm-Message-State: AOAM533h+xZrs2PIBnKU/v7pfpLTU68LSC8heO4OjseErVgO4BhVJ5kY
        x009gR8RmYqgG0FH57Giw2Lsiw==
X-Google-Smtp-Source: ABdhPJyHIKw9WEzh6N3BXcgx11UwI1xf/377zz0nUKvGGyqiZiH4zAvWq3AiOlscznnhY/lIRP2Cng==
X-Received: by 2002:a1c:2c45:: with SMTP id s66mr17990066wms.40.1592813026778;
        Mon, 22 Jun 2020 01:03:46 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:110:673c:7143:200f:54b7])
        by smtp.gmail.com with ESMTPSA id k16sm16791759wrp.66.2020.06.22.01.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 01:03:46 -0700 (PDT)
Date:   Mon, 22 Jun 2020 10:03:45 +0200
From:   Matthias Maennich <maennich@google.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Julia Lawall <julia.lawall@inria.fr>, linux-kernel@vger.kernel.org,
        kernel-team@android.com, YueHaibing <yuehaibing@huawei.com>,
        jeyu@kernel.org, cocci@systeme.lip6.fr, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] scripts: add dummy report mode to add_namespace.cocci
Message-ID: <20200622080345.GD260206@google.com>
References: <20200604164145.173925-1-maennich@google.com>
 <alpine.DEB.2.21.2006042130080.2577@hadrien>
 <bf757b9d-6a67-598b-ed6e-7ee24464abfa@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <bf757b9d-6a67-598b-ed6e-7ee24464abfa@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 04, 2020 at 02:39:18PM -0600, Shuah Khan wrote:
>On 6/4/20 1:31 PM, Julia Lawall wrote:
>>
>>
>>On Thu, 4 Jun 2020, Matthias Maennich wrote:
>>
>>>When running `make coccicheck` in report mode using the
>>>add_namespace.cocci file, it will fail for files that contain
>>>MODULE_LICENSE. Those match the replacement precondition, but spatch
>>>errors out as virtual.ns is not set.
>>>
>>>In order to fix that, add the virtual rule nsdeps and only do search and
>>>replace if that rule has been explicitly requested.
>>>
>>>In order to make spatch happy in report mode, we also need a dummy rule,
>>>as otherwise it errors out with "No rules apply". Using a script:python
>>>rule appears unrelated and odd, but this is the shortest I could come up
>>>with.
>>>
>>>Adjust scripts/nsdeps accordingly to set the nsdeps rule when run trough
>>>`make nsdeps`.
>>>
>>>Suggested-by: Julia Lawall <julia.lawall@inria.fr>
>>>Fixes: c7c4e29fb5a4 ("scripts: add_namespace: Fix coccicheck failed")
>>>Cc: YueHaibing <yuehaibing@huawei.com>
>>>Cc: jeyu@kernel.org
>>>Cc: cocci@systeme.lip6.fr
>>>Cc: stable@vger.kernel.org
>>>Signed-off-by: Matthias Maennich <maennich@google.com>
>>
>>Acked-by: Julia Lawall <julia.lawall@inria.fr>
>>
>>Shuah reported the problem to me, so you could add
>>
>>Reported-by: Shuah Khan <skhan@linuxfoundation.org>
>>
>
>Very cool. No errors with this patch. Thanks for fixing it
>quickly.

I am happy I could fix that and thanks for confirming. I assume your
Tested-by could be added?

Is somebody willing to take this patch through their tree?

Cheers,
Matthias

>
>thanks,
>-- Shuah
>
>
>
