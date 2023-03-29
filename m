Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEAC56CF16D
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 19:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbjC2Rto (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 13:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjC2Rtn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 13:49:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA1310E
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 10:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680112142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IONsVIcn8kbwJf2seRI8PrEqiqdrN9HzkrIGpJGRGFc=;
        b=i0UsfHcQcfdgq6vst4WGz8RESQzl4O6TP0Mr4/NYYKRmZkjE8TLH986RrDRfd3nzVCM36S
        PmRFDTb2eyn7z3zvbCCwKwpqt678Y0RZ4LMT9GtYEpTrBYVZ0Z4Uyq9wANUYEGS/9PKrCE
        Zh1YpqbzsIlhfFt6dBgZje3Z6OldYaQ=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-245-YDWT2NFCPEKM2OhHOm6oBA-1; Wed, 29 Mar 2023 13:49:01 -0400
X-MC-Unique: YDWT2NFCPEKM2OhHOm6oBA-1
Received: by mail-qv1-f69.google.com with SMTP id pr2-20020a056214140200b005b3ed9328a3so6962151qvb.10
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 10:49:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680112141;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IONsVIcn8kbwJf2seRI8PrEqiqdrN9HzkrIGpJGRGFc=;
        b=zNiMhcNxPhnCZ8skKqZyMbGZKTRXlxW3ak+Zz28TljSMcI1hPOmen1vqnii0X1bSs0
         naztrXAVkwnnrHIJZDLfioeqw3sPp2NBKunMbgwbwN+7VbeoujoLnFjRvcUqVwWUoGZH
         TFZ/Lr42Om8bzrjFlME3GBHgiyDPCTEYGN7ZtWzJdTNol4eHTiMhOU2kmjmhsxYxCThH
         1SchsFnT6Jxon6L8k5DekUln7JT5V6Dc79H1sVHPCHur+XAkoFgn/PX48MOTb9tLupwL
         Yj9CbTA1DmTuEe1zV4BC6EvH3OdUj2l3e2ZqUPLtCm/jaP0iEXk7C8AeFtrhngIABMst
         WuEw==
X-Gm-Message-State: AAQBX9dKl4dyyTTl1oz3jFCUwWodFgemWd/USXuFwPsxu9ZRq2KuMLD6
        RA9wRhQsyoKhUBPanF5LgZXSoRpM6NAMeNHqSH1KG/1KxYMIMNSzStGQ6nO1RO+m+zETAYOJYTM
        c8w5lvtXhyeKB3RRj
X-Received: by 2002:a05:6214:5299:b0:56f:796e:c3a5 with SMTP id kj25-20020a056214529900b0056f796ec3a5mr33440982qvb.4.1680112140878;
        Wed, 29 Mar 2023 10:49:00 -0700 (PDT)
X-Google-Smtp-Source: AKy350aI2qlfzgI2jwFvg3qZMpYzAQdHa4DExATysZa4PwrH9UwHFxOYyuR61+4tFE0cJ4kmmOzrCA==
X-Received: by 2002:a05:6214:5299:b0:56f:796e:c3a5 with SMTP id kj25-20020a056214529900b0056f796ec3a5mr33440968qvb.4.1680112140666;
        Wed, 29 Mar 2023 10:49:00 -0700 (PDT)
Received: from fedora (modemcable181.5-202-24.mc.videotron.ca. [24.202.5.181])
        by smtp.gmail.com with ESMTPSA id mu10-20020a056214328a00b005dd8b9345aasm4699202qvb.66.2023.03.29.10.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 10:49:00 -0700 (PDT)
Date:   Wed, 29 Mar 2023 13:48:58 -0400
From:   Adrien Thierry <athierry@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        Stanley Chu <chu.stanley@gmail.com>
Subject: Re: [PATCH 6.2 128/240] scsi: ufs: core: Initialize devfreq
 synchronously
Message-ID: <ZCR6CiexABbS9AVI@fedora>
References: <20230328142619.643313678@linuxfoundation.org>
 <20230328142625.117629733@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328142625.117629733@linuxfoundation.org>
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

