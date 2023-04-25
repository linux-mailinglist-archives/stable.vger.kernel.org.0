Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E84A26EDEDD
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 11:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbjDYJO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 05:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233653AbjDYJOz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 05:14:55 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FE97AA6;
        Tue, 25 Apr 2023 02:14:54 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-4edc63c82d1so5641393e87.0;
        Tue, 25 Apr 2023 02:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682414093; x=1685006093;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cjfVaIf6plXwAD6EZTSs6TefR4Aelbcp2IzWurJM8uU=;
        b=Uqnypg2+q/n2EPC7Uq75BU4rKtxwNFj09YWBtz8DI7mKOtJxsgP6dMIUJEDffOnFdl
         18gt8ZnbWHSa0HQA7X44RsIkz9DUhdOnCcltzrvurKMotaKdfemJqBabNRShycVugLuV
         PLOdiqmqxd5WPYDFoCl+G3/NfTJ/LXFZT4wTlhU68bE9kH7VnTzT/51nepKPDcxkuQsM
         ktq6Lilic6nLzQhYwOfHB1e8G1zUZAKrQDsb7V+3TKGShunNYLoeddlNFpzIozA/sjsm
         x/R/JSk3UzfnvC7guv2YHruLWzF8B+UWJmf60GsCRTlWvHGrLyxkUo2NLxSfHbLi+/yc
         YRvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682414093; x=1685006093;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cjfVaIf6plXwAD6EZTSs6TefR4Aelbcp2IzWurJM8uU=;
        b=bwSwVecSzqn4hbOjMa7NJm1dFzx1ArXJ8UrDV58DbQEagBjsWOenNEn3nxdxrxc4nf
         KgqzP/QUiL9fkqQg9QnrGWdw4lhONivja+jU9FZMKA04WQaMTP3Xajc7swRM7htwwxMm
         WHcivI8VThVeB6+EKXiFSYqtvQCaYlvcpC5kGyBVUQ1ogFW1PhnKj5byyf95lKOH81KV
         8iJGNQSHbQ07/Z80WeP3Yo2VoqMNqrC/hMEagXaGW4hCv7PWGkr9EjVq7m6EiFo2fi0Q
         3wz+YwbWdQBDagN8MtXbnn2ZSL59i7i7EXOVy7iWkHQ/ulXhjPh5FrRmNaapoOz3hubc
         /Kig==
X-Gm-Message-State: AAQBX9cmYqRT4KaCteVHN5Da368cW9udPF2GmHcW8boBeHqxUCyAabfW
        9ZJRSSLYXWOvgVuOLJxgQFE=
X-Google-Smtp-Source: AKy350ZBRwmSjoSNB53w3tOiA4fDAKDp82e2PMBXN8ZwrkMhqssFD3smdauH1dNzw867qj9GwEzxVg==
X-Received: by 2002:ac2:5a02:0:b0:4ee:e0c7:434d with SMTP id q2-20020ac25a02000000b004eee0c7434dmr4094426lfn.51.1682414092352;
        Tue, 25 Apr 2023 02:14:52 -0700 (PDT)
Received: from pc636 (host-90-233-222-113.mobileonline.telia.com. [90.233.222.113])
        by smtp.gmail.com with ESMTPSA id v19-20020a197413000000b004edc512515fsm2001253lfe.47.2023.04.25.02.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 02:14:52 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date:   Tue, 25 Apr 2023 11:14:49 +0200
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        stable@vger.kernel.org, RCU <rcu@vger.kernel.org>,
        Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>,
        Ziwei Dai <ziwei.dai@unisoc.com>,
        Mukesh Ojha <quic_mojha@quicinc.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH 1/1] linux-6.1/rcu/kvfree: Avoid freeing new kfree_rcu()
 memory after old grace period
Message-ID: <ZEeaCb6dQepMrxEk@pc636>
References: <20230418102518.5911-1-urezki@gmail.com>
 <20230418102518.5911-3-urezki@gmail.com>
 <2023041844-chasing-skincare-4cfe@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023041844-chasing-skincare-4cfe@gregkh>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello, Greg!

On Tue, Apr 18, 2023 at 12:42:12PM +0200, Greg KH wrote:
> On Tue, Apr 18, 2023 at 12:25:18PM +0200, Uladzislau Rezki (Sony) wrote:
> > From: Ziwei Dai <ziwei.dai@unisoc.com>
> > 
> > commit 5da7cb193db32da783a3f3e77d8b639989321d48 upstream.
> > 
> 
> What about 6.2.y?  You do not want anyone upgrading and having a
> regression, right?
> 
> Please submit a backport for that tree too if you want any of these to
> be applied.
> 
Sorry for the delay. I missed your email, it landed for some reason
into wrong email folder! That is why i did not react.

I will prepare a backport for 6.2 and will send it shortly.

Thanks!

--
Uladzislau Rezki
