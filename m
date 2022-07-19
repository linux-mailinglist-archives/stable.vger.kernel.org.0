Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B891F579FE8
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbiGSNpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239334AbiGSNo6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:44:58 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B98376464
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 05:58:17 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id n185so8904214wmn.4
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 05:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=JXHp6pIxPy+wgaPGh3LoqXThJCcrgYdrqg/OfPyajuc=;
        b=KYKy2ar+XFWKf2wUx6cxp33A5RoGceHdBo9Z0GeyhAABxmQKwlRRyW/kGV4ojDvbHm
         64WznLyCb5/6ZnGGe1fMv0lOQZ1wbcTnDqOz8LeEUfbckMkE7Mgh5RftuOWKv3tzILxf
         wxepqtf0CD+RdbiJsM2Yl4pPhTU0ZV81UYnVOIRmubUJRLsXv0zPiuUUpkT6jxlXCvp0
         8MwDtNiYwIWOkUISKT7MCNAYvj5x3vTpkajGnoGmY0UZyYp5PiQ8SB1cUgTR/sd/hSgH
         xCe5EP6yyGocVF8r91DzGOJjknmXU5GCsjVJrJxW1gTC9z0GZRH36Z7rs5e9rOYaehpM
         lBpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=JXHp6pIxPy+wgaPGh3LoqXThJCcrgYdrqg/OfPyajuc=;
        b=dZXcb7mei+DpdAugwZiNDrq5+tfxxIfK3udUI9WUILC3Ib+pSexyCvcoA11X2XLRue
         hXVY/SGaxfYsnAsqQiOnelaoJBpGsCJgdZz1Jiy3fGxy3JziAkGotUh3eJ5+HTvJN+SX
         ht7k7Ljt6HIZBE7ZuT/I4iF3Ol9wuuuPs5m1yGVfGNCOB4ZBNQmHZ1Psvkwsa5e6ENHo
         8S+j/T/9kPuo+hOU54adcumgjsdd6SJDfzL6Zg9ejR24RnP1OZM42vycEN9xEbNc6Qaa
         cdIdO+v+fznZ7ZzjYzd0Y1WxP2XE+14dBZQIt/WUerQmPsf0sVyE7vbhYfk0tXlSjgBs
         9VyQ==
X-Gm-Message-State: AJIora+AnS8oPS9D0IDDTnL/Yhxq+yiy9O/mRZLFZ+vEQJI8fZ/cEnM8
        HpY1LX6au2PJL3Vy0ESvwBAjFQ==
X-Google-Smtp-Source: AGRyM1sdAqGK51Ry5I3l8ch92vW/ixq+C3UcBLqFGHPLJAnOBHb38/UtsSCt8tlWkv0IKj2/fWSJRg==
X-Received: by 2002:a05:600c:1e04:b0:3a3:11ca:5c0c with SMTP id ay4-20020a05600c1e0400b003a311ca5c0cmr15400294wmb.31.1658235494686;
        Tue, 19 Jul 2022 05:58:14 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:fc72:8c85:fca1:4e18? ([2a01:e0a:b41:c160:fc72:8c85:fca1:4e18])
        by smtp.gmail.com with ESMTPSA id m185-20020a1c26c2000000b003a302fb9df7sm18615177wmm.21.2022.07.19.05.58.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 05:58:14 -0700 (PDT)
Message-ID: <390e3dc0-9a10-621b-f8e8-1cf15fa32bf1@6wind.com>
Date:   Tue, 19 Jul 2022 14:58:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net] mlxsw: spectrum_router: Fix IPv4 nexthop gateway
 indication
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        dsahern@gmail.com, mlxsw@nvidia.com, stable@vger.kernel.org
References: <20220719122626.2276880-1-idosch@nvidia.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220719122626.2276880-1-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Le 19/07/2022 à 14:26, Ido Schimmel a écrit :
> mlxsw needs to distinguish nexthops with a gateway from connected
> nexthops in order to write the former to the adjacency table of the
> device. The check used to rely on the fact that nexthops with a gateway
> have a 'link' scope whereas connected nexthops have a 'host' scope. This
> is no longer correct after commit 747c14307214 ("ip: fix dflt addr
> selection for connected nexthop").
> 
> Fix that by instead checking the address family of the gateway IP. This
> is a more direct way and also consistent with the IPv6 counterpart in
> mlxsw_sp_rt6_is_gateway().
> 
> Cc: stable@vger.kernel.org
> Fixes: 747c14307214 ("ip: fix dflt addr selection for connected nexthop")
> Fixes: 597cfe4fc339 ("nexthop: Add support for IPv4 nexthops")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
