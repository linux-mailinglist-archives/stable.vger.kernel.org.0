Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78C496CF15A
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 19:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjC2RrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 13:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjC2RrD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 13:47:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE1A5FC4
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 10:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680111978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IONsVIcn8kbwJf2seRI8PrEqiqdrN9HzkrIGpJGRGFc=;
        b=BOCH9RYq0dBItl84+WDIVBA99jSqZltI+gsJa18NV/goBmvkb5vYJWYzKWRMbUbWZNM520
        Rvehnf1izGaNVAvyJXlkoJbRhfQXgCt/BNtjRJcm/2617R8PGLeS/p42VCnHQ9pzDaGuTP
        hrMQk88ZPEsxdp4RlSYeMqQTdtRi534=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-220-EGZklzdFMCCz8CbysOGNQg-1; Wed, 29 Mar 2023 13:46:16 -0400
X-MC-Unique: EGZklzdFMCCz8CbysOGNQg-1
Received: by mail-qv1-f71.google.com with SMTP id q1-20020ad44341000000b005a676b725a2so6939361qvs.18
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 10:46:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680111976;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IONsVIcn8kbwJf2seRI8PrEqiqdrN9HzkrIGpJGRGFc=;
        b=sO2zoidOW+IyCJEpVUhpKu5qGLkSxQ+/km2R4qps0Uay3M34YLuWFkvJ2fESgdCkaz
         d8QFWOMda4sHJyGs2QdVy2JfMD6itCKieB25cc3zZJ5fMVb7f3Spj8cqtoolLkwqTn7p
         bNmmpH1wlclNjzmY0VisC7sp0tKkZ1ME1yrFyCv9IsGYBYww57sI9n23r7OlPy5XOMc1
         ihUkxpgpnbkMBSWB/hZMZ2X/C2g5bqEq1WJ3lS4XCjt3wXJVdbUFJyJlm4K+LqKunwM4
         ZI80IZW18iaQwrQ7N9EgS89b2PmUFF50Hw97yH3XlAqk6Ivqe/PHqczJtt0hIqPZw/Rc
         0zPQ==
X-Gm-Message-State: AAQBX9cbpU76mOlK+ejRXZRrmXPmAD2R205rkVBdx65dbeLHICt+XbGe
        RvsZOM2b0a9MlaB4vazZWdBKUtOnGbY+5yUSSLIvMz+4ZjxAYRkcrO2ZALcQGKwsqQtsdhPpYb7
        YOVe6wFei/SjdPAxaRFQiN/BM
X-Received: by 2002:a05:622a:188:b0:3e4:eb8f:8a7b with SMTP id s8-20020a05622a018800b003e4eb8f8a7bmr4376572qtw.29.1680111975899;
        Wed, 29 Mar 2023 10:46:15 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z1kJwhD5xCTJat8Q4ohGC869VT82gZmyP61KC92Wq3+k/cmmICrDwvYCiuz1nI/CkWFS+EiQ==
X-Received: by 2002:a05:622a:188:b0:3e4:eb8f:8a7b with SMTP id s8-20020a05622a018800b003e4eb8f8a7bmr4376550qtw.29.1680111975633;
        Wed, 29 Mar 2023 10:46:15 -0700 (PDT)
Received: from fedora (modemcable181.5-202-24.mc.videotron.ca. [24.202.5.181])
        by smtp.gmail.com with ESMTPSA id j68-20020a37b947000000b0074577e835f2sm18758803qkf.48.2023.03.29.10.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 10:46:15 -0700 (PDT)
Date:   Wed, 29 Mar 2023 13:46:13 -0400
From:   Adrien Thierry <athierry@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        Stanley Chu <chu.stanley@gmail.com>
Subject: Re: [PATCH 5.15 082/146] scsi: ufs: core: Initialize devfreq
 synchronously
Message-ID: <ZCR5Zef4oHYFkAss@fedora>
References: <20230328142602.660084725@linuxfoundation.org>
 <20230328142606.118680029@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328142606.118680029@linuxfoundation.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A possible regression was found with this patch [1]

[1] https://lore.kernel.org/all/CAGaU9a_PMZhqv+YJ0r3w-hJMsR922oxW6Kg59vw+oen-NZ6Otw@mail.gmail.com

Best,

Adrien

