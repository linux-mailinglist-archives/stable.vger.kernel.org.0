Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A32058FDF2
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 15:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235369AbiHKN7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 09:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235368AbiHKN7d (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 09:59:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72C0083F30
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 06:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660226371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rYsvZrJERSFCTDNNMPCNpBJ2PLMPF48eso2jkLERrqI=;
        b=WB6ihcyreP9rV/mYRKiX3yjqAQv0UMjG2pAhpyNIl3H71CQhBaEWS4rIZiMrxLrjElxImg
        Dsd+NUiw0ljJEC1vqo3ctfeknxdDSZbgcNY19oCRMYDa7zfXvy0dh2kBT1586tQK9fnx0K
        nIu7mohOBQrRwalGftr37LB3mCyyJpw=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-384-mK1O-9E7O5yN6IHEVG41FQ-1; Thu, 11 Aug 2022 09:59:30 -0400
X-MC-Unique: mK1O-9E7O5yN6IHEVG41FQ-1
Received: by mail-io1-f71.google.com with SMTP id o23-20020a056602225700b0068002601976so9662659ioo.18
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 06:59:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=rYsvZrJERSFCTDNNMPCNpBJ2PLMPF48eso2jkLERrqI=;
        b=ptUIqGT/n7Tu406njxVHkw9ou7PQN7iOjwPVguvNfChnQeEiATgAG44Yaz4FpuSK7e
         smJhLBsmVpazAtgk+uQVrMxfjZ/HB1IAMGN2xylA6fU50gj0ZzIfSCrJVsoNQRax4Msh
         Ki5D8VKrZVD4RHe6DtGGCKCSoV9cDhCvriApYkDlO3H36jXTU9yiYj9JUeKT38srw5er
         P78t9n8RuX/hphzzfhui+UTCFbqdSN4CzRxNY6HxGzbNlRo5S9Jk80ZIZqIJsuL+FWgI
         ImEP6auQecZZqNbmMecmr26ew9cmBoSB3CRcin5PncF+oVDY0tHcL7v+NPBRXxwZj+7q
         6H4w==
X-Gm-Message-State: ACgBeo3jnkB5ZgyZ2WSVzWQj8qo033D7HwEjEUhDKFcuTSHEQiWvb10r
        T3oNyozlrkgKABQbxW/BPJq2TnQrIgkZ2fbVsSseIsd3P5WiFEnZUr7nkF+GjhhVd4LYM2Mit/9
        /ad596/s79p340oWr
X-Received: by 2002:a5d:94d6:0:b0:67c:55f9:f355 with SMTP id y22-20020a5d94d6000000b0067c55f9f355mr13681376ior.133.1660226369706;
        Thu, 11 Aug 2022 06:59:29 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5ossnAlVawJyNxLHxJt1o91JZHF+X86cJ+p5vveqCWlIHRg8yryGgz/8GYw73807O65wwgAA==
X-Received: by 2002:a5d:94d6:0:b0:67c:55f9:f355 with SMTP id y22-20020a5d94d6000000b0067c55f9f355mr13681368ior.133.1660226369453;
        Thu, 11 Aug 2022 06:59:29 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id t8-20020a92cc48000000b002e157453a74sm2813487ilq.28.2022.08.11.06.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 06:59:28 -0700 (PDT)
Date:   Thu, 11 Aug 2022 09:59:27 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/hugetlb: support write-faults in shared
 mappings
Message-ID: <YvULP8DtFFhJYNO4@xz-m1.local>
References: <20220811103435.188481-1-david@redhat.com>
 <20220811103435.188481-3-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220811103435.188481-3-david@redhat.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 11, 2022 at 12:34:35PM +0200, David Hildenbrand wrote:
> Reason is that uffd-wp doesn't clear the uffd-wp PTE bit when
> unregistering and consequently keeps the PTE writeprotected. Reason for
> this is to avoid the additional overhead when unregistering. Note
> that this is the case also for !hugetlb and that we will end up with
> writable PTEs that still have the uffd-wp PTE bit set once we return
> from hugetlb_wp(). I'm not touching the uffd-wp PTE bit for now, because it
> seems to be a generic thing -- wp_page_reuse() also doesn't clear it.

This may justify that lazy reset of ptes may not really be a good idea,
including anonymous.  I'm indeed not aware of any app that do frequent
reg/unreg at least.

I'll prepare a patch to change it from uffd side too.

Thanks again for finding this problem.

-- 
Peter Xu

