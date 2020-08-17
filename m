Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98FC24674E
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 15:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbgHQN1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 09:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728274AbgHQN1T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 09:27:19 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48171C061389
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 06:27:19 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t10so7514282plz.10
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 06:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=awIowO0lQhw9fWxoa11p+lKyeUnE58YJsyPDXVW7aXI=;
        b=najPFqGfJ/y5MkNJzpDK/b55Ak04TqLTKbQ5z575lTTvFiByd84VuXDzLGHEcMpF2O
         TwROb6yLjIM2RwU8WQG4oTJkkNsywYBcE95U7qayRkcrpfm5H8O9SdJobq3WPxYgZqD1
         oDG2Rq6lIxjyelWQOtAhFM5INo1HX2OqQQ3a/CydwWm5sfMuboCjRjs5rTxqgO3jR+M3
         i9AE5sRgBGvp0Q/H8QPxMP/K1vXuJxwWRtKZErU4e1bxkD2IiXNg0xptaZ6Q+RI+xJ/l
         AFcITd8JP/wBZ+tNkqZmGcJODhDKS007axzCscm+DsT3lwchYGHzNmhw60dpl0Q6xEG+
         szsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=awIowO0lQhw9fWxoa11p+lKyeUnE58YJsyPDXVW7aXI=;
        b=VDbH38pZI891MfQYz5puUO+/UqMwxEWO247udgAAC4S+M55SMIJlT4sxTu/nfJ7hyX
         ukOEmCDaDGhhGEcD2H1Ve8EGOAFgweC33Ak+EzNsXPmoDsY6R65E96X9rHjJpp4LjH6/
         aglnERXKr2oHvPtn4clmCxb16gGppHZNaWGWu1Fwiuw/rYscpJByE1xE0OB2TZqq5czK
         Ux26nHs+OEjYTs7DuyS9i3ZiwR9lBWUW46/D1mOFrN9qpJIvfs62B9Y96BSb8GqrT8uY
         cT+0dySVR7bf3vukj4R5HW4zp3gcwcLLD1BQFAbGgUgQLFjyArNmHgRjyZkI4p+EKV7b
         YRvg==
X-Gm-Message-State: AOAM530nlfb7MIWwCI11bu1kCPn3JlhivTQuKRIz7v1kauFpcK3CNBVn
        eCUK0D/IeNw0OR078sQCJf8FmYLBtUzKsQ==
X-Google-Smtp-Source: ABdhPJyLuBGZFnRlXiy3plub5LM7/Z8LamK403abeLIqkCNQLGlEWO5vl1rFzGb5LL5vHo5zLaNe2Q==
X-Received: by 2002:a17:902:323:: with SMTP id 32mr3794531pld.59.1597670838599;
        Mon, 17 Aug 2020 06:27:18 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ff2c:a74f:a461:daa2? ([2605:e000:100e:8c61:ff2c:a74f:a461:daa2])
        by smtp.gmail.com with ESMTPSA id b15sm17307463pgk.14.2020.08.17.06.27.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 06:27:18 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: enable lookup of links holding
 inflight files" failed to apply to 5.4-stable tree
To:     gregkh@linuxfoundation.org, josef.grieb@gmail.com
Cc:     stable@vger.kernel.org
References: <159766102725059@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6a284d31-e8a6-8922-2784-2fcd45ddfc82@kernel.dk>
Date:   Mon, 17 Aug 2020 06:27:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <159766102725059@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/17/20 3:43 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

5.4 doesn't need this patch, you can drop it.

-- 
Jens Axboe

