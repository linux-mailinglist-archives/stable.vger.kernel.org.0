Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC5146D56F4
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 04:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjDDC4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 22:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232934AbjDDCz7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 22:55:59 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0471FE0;
        Mon,  3 Apr 2023 19:55:58 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id d13so29171930pjh.0;
        Mon, 03 Apr 2023 19:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680576958;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jVV9cxKF8CzU0gUghTh55PDDFH6OAM8gy1Kv/8QwOlg=;
        b=fKxyz4NrEX6JrxqjGGRBECbIfAiBm10rZP7AV+C0+d/iGU7MOApwh0/E3YyoP5xuLT
         B4kuBX1gYp2fJSkWfjgtqlFqdsagm9WDo0pS1zf54P0Pw44yFI8lgWtsacZMjkGfrZqp
         AJqB2XjxIzwiwMaJC9nd0tE4lvBp/GAgRa0TDB+FOxi8ybACYJHfICrpkZdOL4LyoLfV
         3Rkj3NcZzkuzOa/Vafb5rDMRWsUu3ikV3HYO9v8OdC8ZHf3UzeMoebsm4wlxHwoRCdCd
         1GTK0N4hM40yTLHet1+FN1vXAZKJbFpD3Sit+6zHc8Si3muHb91ImcKQqQIeTKZu8d3C
         4zMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680576958;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jVV9cxKF8CzU0gUghTh55PDDFH6OAM8gy1Kv/8QwOlg=;
        b=avspT5jHgbN+ZPKqoeRdWmERfeFUty0Sna1nxm2FAqSNGfQjBKuk0qdx4i3kbBCSqt
         UPPvh05vf/9qQaOq0jKLrGTxKTHQf37kaRXOSziWPYpvB1Oh8UNcT5kOe/seDeDggagO
         z2ljJbG/3nOZt/j9BjKboFpnWD/qVlt2jwj7VZMbj8uVi8FTdl6zQhJi/pebQv6NyfmS
         s63VZK1k47O0O99vycQd9WMx92w7w2Q8c4BW9JAA/ekQUdxoXmjEXr2S2Zn4uiey5BvT
         xS52OmVehvaPBoWkK7nNLdXvZs2VTs5QsDaG09HFoubB+SziJBEpZZyVwIkGm+xNE/6R
         fW5A==
X-Gm-Message-State: AAQBX9fgxFZEr9sJXLCfCP5Uvn85r9CFIXHN1OTbaNA7WRMUwEh/DHKP
        Di3xo+gxK6HN5nvjtVbF2Sc=
X-Google-Smtp-Source: AKy350YDPvn5VoLxr2Aiy2EYPVkBZrOgl04a0POrH1smAYsgcbEjD/TnzpnM99ITKI2LP30MnRcerA==
X-Received: by 2002:a05:6a20:1b14:b0:d7:34a1:859a with SMTP id ch20-20020a056a201b1400b000d734a1859amr958170pzb.27.1680576958291;
        Mon, 03 Apr 2023 19:55:58 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-87.three.co.id. [180.214.233.87])
        by smtp.gmail.com with ESMTPSA id i35-20020a631323000000b00502f017657dsm6514157pgl.83.2023.04.03.19.55.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 19:55:58 -0700 (PDT)
Message-ID: <3d994c05-492d-f9f4-161d-123a68d4e87a@gmail.com>
Date:   Tue, 4 Apr 2023 09:55:53 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v7] tty: fix hang on tty device with no_room set
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     juanfengpy@gmail.com
Cc:     Hui Li <caelli@tencent.com>, stable@vger.kernel.org,
        =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1679019847-1401-1-git-send-email-caelli@tencent.com>
 <ZCuQO3A6FX305KTJ@debian.me>
Content-Language: en-US
In-Reply-To: <ZCuQO3A6FX305KTJ@debian.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/4/23 09:49, Bagas Sanjaya wrote:
> On Fri, Mar 17, 2023 at 10:24:07AM +0800, juanfengpy@gmail.com wrote:
>> We have met a hang on pty device, the reader was blocking
>> at epoll on master side, the writer was sleeping at wait_woken
>> inside n_tty_write on slave side, and the write buffer on
>> tty_port was full, we found that the reader and writer would
>> never be woken again and blocked forever.
> 
> Where do you find this hanging pty? Seems like the wording makes me
> confused. Maybe you mean "It is possible to hang pty device. In that
> case, ..."
> 

Oops, I forgot to Cc: LKML.

-- 
An old man doll... just what I always wanted! - Clara

