Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC3C52D224
	for <lists+stable@lfdr.de>; Thu, 19 May 2022 14:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbiESMLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 May 2022 08:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237734AbiESMK4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 May 2022 08:10:56 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9738BBA560
        for <stable@vger.kernel.org>; Thu, 19 May 2022 05:10:50 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id c14so5007433pfn.2
        for <stable@vger.kernel.org>; Thu, 19 May 2022 05:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:cc:in-reply-to:content-transfer-encoding;
        bh=IAWQxH0dJl2jOBvpD083FR1kZUWTWgx/4xKjUxWpa9c=;
        b=D/6USgNza0Oe/NOPEuo8UoSUA2GNOmxc9GjvW1HEzMLXBh4XVyjN0GGEsJQyrYh8ol
         ryGgT/lUZ2u/U+ajzoe17+qCuGLRq1GPLuh45rwrDU3HoqkrgN+ojNgoDUImw/ckmqfn
         zgyZQiMe/txOCS5x/RAFfgZgKpqH9ukhsibRa03d5eLDB8DIbkLfgJ9jaAMUli6nuRLk
         2BySA0CW0U2MWwPi7iAm9AVovG0eHWn2rCCZrrY2jhJqKqA91TytsISD1CQmJkSG4hJO
         shpLT9fmNubjWhF9M7+zdA+/08MQsNG3znwqczCX5AM878LyttC77HlBkPsrHpQ+uUnz
         a29w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:cc:in-reply-to
         :content-transfer-encoding;
        bh=IAWQxH0dJl2jOBvpD083FR1kZUWTWgx/4xKjUxWpa9c=;
        b=Xhw5wVNHcjweggJRWdoZwOfw+zNvhmiiLeCkwpBIMMfcuo3DDkwZyQZyJS/iwvn85L
         1Mo5FMRUJah5p92bbBh8OpIw7BNf9Llc3kAW/wVe63jnkqHplwlt0iNnvOZ/uwScyvxx
         iEzsGIct3oxFnrvlEqSrVtiPSZvOz93WG0xYm4CusKhj/ayY/SI+/CtRLZ81qqZRceO8
         O3Va5dYmaY7Fbyu61LyTiXk4LCwu+bEEC+EbcdNoGD/pbui7yMtWYLSAg7bf1MRVhCJ3
         VWvoiiyr9Ld8YDiU8LHnopIN40EajArYySraL4hmMm6lsxYwszN3n6yxnEftRtnMnObF
         AA5g==
X-Gm-Message-State: AOAM532AM30uYXtbKJ9HSL+YrnPcBJjgcELNTFfgBfQQTP36duQZP7V7
        qQ8HZqjuGMmTioq/q2jLvZT7kldmJ6ZWlQ==
X-Google-Smtp-Source: ABdhPJw7fI6gboXT/O5eQjUUPlZc0USv+HCTZ5vTO2VmK2Rb1U/9TU4b7/yFIuxhX90VewEp3VwI0w==
X-Received: by 2002:a63:5824:0:b0:3db:65eb:8e2f with SMTP id m36-20020a635824000000b003db65eb8e2fmr3734214pgb.349.1652962249910;
        Thu, 19 May 2022 05:10:49 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g19-20020a170902869300b001618fee3900sm3636534plo.196.2022.05.19.05.10.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 May 2022 05:10:49 -0700 (PDT)
Message-ID: <b0d16f69-f345-3a6a-3e42-122016fb601a@kernel.dk>
Date:   Thu, 19 May 2022 06:10:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: Cherry-pick patch request for 5.15-stable
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     stable@vger.kernel.org
References: <032e7301-10ef-c392-04ed-345763e893da@kernel.dk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
In-Reply-To: <032e7301-10ef-c392-04ed-345763e893da@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/17/22 8:37 PM, Jens Axboe wrote:
> Hi,
> 
> Can you cherrypick:
> 
> commit e74ead135bc4459f7d40b1f8edab1333a28b54e8
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Sun Oct 17 00:07:08 2021 +0100
> 
>     io_uring: arm poll for non-nowait files
> 
> into 5.15-stable? It should apply cleanly.

I didn't see this in the 5.15.41 release that just happened
yesterday, just a ping to remind you that this is needed for
5.15-stable.

-- 
Jens Axboe

