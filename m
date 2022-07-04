Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5EF565734
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 15:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbiGDNbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 09:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233811AbiGDNbR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 09:31:17 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC4526F5
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 06:26:04 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 145so8924678pga.12
        for <stable@vger.kernel.org>; Mon, 04 Jul 2022 06:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=UuagIt1u3IXFBdgD5nFgh0Bg7zljEhO9IIZVJV9xaZ4=;
        b=mA7SqDThEfLqlNqB71baDf98WeeuuRxiL6ZUu29ne7+chPJ33tIF2fyStBnVOvGpBD
         ccKoTvJwkxjVmB7TYIYDskoY7umFFj3z23V32sDi4i6KjiSEnNX6lihwdCsaT+LeYCYf
         ocAp83U80C3kA1iSibT+x1ebCH6eacTLnBzl/95RBWNc81gY2OpsTlJ1Hpsd+xCnFH+b
         qxg0b13oUbc9TCGVUrQV04eZ2By7bZZPn1R6OQrYWyZpGVqhJCUdTriripySTJ3fEiir
         dUyGMkAkA4r493p4765wFg+pQScYsJ39jmVBj9oQznkSW+iBUuZGUbKs6JorR4cXXn8w
         iBkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=UuagIt1u3IXFBdgD5nFgh0Bg7zljEhO9IIZVJV9xaZ4=;
        b=bU3Nki3IsIDBXiME6TJfsBS9nL9KRsy0zp/UZs5F2fQJj9u4krxY1lH2vaS8jrB6Cd
         5cUzmNQKFo/ZdO6+cAyLHGT7O4yjILdlcPtJE/NI4+7uePYCAfo3CPxRv0xwzQrZCvta
         YcUjzubfkHcIzC/lDfGDQRp2odzgJ4Sd5Cn2z+sHOuMeSCF/Ml+fTdj9eir+JIJ9IQo6
         b+VBFKu5dfOQIRFx1b7mD//ZdPFefKde1H1BD/0SkAwVg71aFBlBdBgHYt+it396c9ve
         0M+lBAWhCyqZ4VkzpeDfse2serLtEHp8MnH3WHCaqlbWHU5huDl5dSxlnCSjtwlrFiel
         veGg==
X-Gm-Message-State: AJIora8K23fTdhNzeiuBw0zFGQcl+p+5g89XyCqYRwELBN5ofOIXsFwe
        wOFShDU7UNXYHSIV6+/9+JIavA==
X-Google-Smtp-Source: AGRyM1sZUl3nMsYh89A7G+NTD7qQ4r2CjiihSxvWg4mw4qf2raXdQLZzZhp542G8PhCrX0GsJu2VIQ==
X-Received: by 2002:a05:6a00:15d6:b0:525:3757:4b98 with SMTP id o22-20020a056a0015d600b0052537574b98mr36616806pfu.64.1656941163634;
        Mon, 04 Jul 2022 06:26:03 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l7-20020a170903244700b0016bcc35000asm5330012pls.302.2022.07.04.06.26.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jul 2022 06:26:03 -0700 (PDT)
Message-ID: <4d63639d-f285-5585-4b6c-14e0bf7cdb17@kernel.dk>
Date:   Mon, 4 Jul 2022 07:26:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: 5.18/15/10 backport
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
References: <36e6d08d-89c0-99e3-a248-1ce79315de03@kernel.dk>
In-Reply-To: <36e6d08d-89c0-99e3-a248-1ce79315de03@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/30/22 2:45 PM, Jens Axboe wrote:
> Hi,
> 
> Can you apply these three patches, one for each of the 5.10, 5.15, and
> 5.18 stable tree? Doesn't fix any issues of concern, just ensures that
> we -EINVAL when invalid fields are set in the sqe for these opcodes.
> This brings it up to par with 5.19 and newer.

Just a reminder on this one, thanks!

-- 
Jens Axboe

