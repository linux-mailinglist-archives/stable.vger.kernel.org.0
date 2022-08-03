Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C69589094
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 18:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiHCQef (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 12:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiHCQee (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 12:34:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7B4CEC78
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 09:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659544472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y7mZEo1wcBJVsL0jcmhax+Kyu3rcBiXL7om6Y/gNwQY=;
        b=Z/CSnYM/WtFcID0elfVWy6H3xDHi8QNzuHOE8/huWafc+wCpvgpIPlRdvQ5w/Z5/NG+hwm
        TjeM25TVwjmYn7I6YbaN4p10i+8Wu2lxkq6n+LG8lPEv71Nhzpq+j99uY2CLiS+X8gLs/j
        hhJ9kLcpV2cLuNzvChGZP6NzyEPrfKY=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-484-zS_fxunaNf-kN6zj6J1NEA-1; Wed, 03 Aug 2022 12:34:31 -0400
X-MC-Unique: zS_fxunaNf-kN6zj6J1NEA-1
Received: by mail-qt1-f200.google.com with SMTP id y11-20020a05622a004b00b0031f22fc45fcso11369750qtw.17
        for <stable@vger.kernel.org>; Wed, 03 Aug 2022 09:34:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc;
        bh=Y7mZEo1wcBJVsL0jcmhax+Kyu3rcBiXL7om6Y/gNwQY=;
        b=rctcs1DZ1GfE1vl/nvTjzwQLhohvRmRTzKymMQopeHLekljWqPnPE+t+6hNrmqrn0N
         NPutr+1mqBNRGNHlOsysw4iK2VeM5EPgS9Ws20pEHo3FprJorfuX+gi85tBCUQOXU4wI
         Irn7wpHgIyvrPVO32F4TrpUnrM08EuDKXqtWp24UCSqatHE03MU8eah2G77mq64/csTX
         KcPbN1EbpAowEJRA0vB7BzJMn3XU2rhbyUD3P6w/iMqN1U0b4qlE1+n/+FSJ/7zB7LGq
         yhUhZdfiL/+2AwqNHHcxzWOYsumSTrCPc5Da+l6WGRCQ3O1DSSJiKYWI5eexskt60+nV
         LYKw==
X-Gm-Message-State: AJIora/ndh5+2mwUs7O8VlH7oMdy6uEwxY5WOVdJ/BCzLuimRKgN05r1
        Oavy3U4XAF0Y9kchNqmw/2N1D/BxsqBQw4Lc8p+I5QevkBdrrYCVyskLAnEItZ9o5ucxYqFCLjM
        Q3ktDAs+Xnn08fHYa
X-Received: by 2002:a05:622a:11cb:b0:31f:e7e:3fb8 with SMTP id n11-20020a05622a11cb00b0031f0e7e3fb8mr23548495qtk.625.1659544470690;
        Wed, 03 Aug 2022 09:34:30 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sOP2eQk3RDZG3U5/vhSN1dYFbdkYJmAKSC1p3WoH26+Hy4E7uo79AbzAxL4Mx4wi4HHFIJ0g==
X-Received: by 2002:a05:622a:11cb:b0:31f:e7e:3fb8 with SMTP id n11-20020a05622a11cb00b0031f0e7e3fb8mr23548477qtk.625.1659544470497;
        Wed, 03 Aug 2022 09:34:30 -0700 (PDT)
Received: from emilne (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id v13-20020a05622a014d00b0031ef366c9b5sm12159054qtw.34.2022.08.03.09.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 09:34:30 -0700 (PDT)
Message-ID: <35b2f5c0cdbf87b7a0abeb69a0fa0ec1a7bdec8b.camel@redhat.com>
Subject: Re: [PATCH] Revert "nvme-fc: fold t fc_update_appid into
 fc_appid_store"
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Muneendra Kumar M <muneendra.kumar@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     linux-nvme@lists.infradead.org,
        James Smart <james.smart@broadcom.com>, stable@vger.kernel.org
Date:   Wed, 03 Aug 2022 12:34:29 -0400
In-Reply-To: <6c03a873a639253c8af685b0e4849fb5@mail.gmail.com>
References: <20220801162713.17324-1-emilne@redhat.com>
         <20220801182714.GA17613@lst.de>
         <0b5001ed-050f-f5d0-72ee-3cc2ffc7f9b8@gmail.com>
         <6c03a873a639253c8af685b0e4849fb5@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2022-08-03 at 10:08 +0530, Muneendra Kumar M wrote:
> I have tested the below changes suggested by Christoph and it is working as
> expected.
> 
> 
> Tested-by: <muneendra.kumar@broadcom.com>
> 

Fine with me.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


