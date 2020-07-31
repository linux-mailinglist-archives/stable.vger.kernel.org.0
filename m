Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92885234C76
	for <lists+stable@lfdr.de>; Fri, 31 Jul 2020 22:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgGaUrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 16:47:45 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:45895 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbgGaUro (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jul 2020 16:47:44 -0400
Received: by mail-il1-f194.google.com with SMTP id f68so4547268ilh.12;
        Fri, 31 Jul 2020 13:47:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MO2GV7Q7hJc5Zuy2tX2Bw37DgW3Q604di6mfkd5jHpo=;
        b=Ksx0z7ZmBm7jUz7PZFfO59M+K2Z1oaAoCP2ct6KQ5Lt6RIczS3C5/IIevhpqQhGcWa
         jkyAjVxLHm8pr2jQjbeLeYyLrYGgcYXZilZqMl+xZfv9mePzefoNqMTjxkicS1Ew1X4t
         e76m0VocLQYRc8QsAjWOjRQlDh4P/ngv5t0TROwYXf0aSrPT95alsvowhDQVBz6oNj+j
         SPx/Dk1FGxtmNXCN92qG67xcoTCDtBiku5x6oVKVtN8s1iW3yJWl6rsB2f5ETu3CiDYk
         6BQ5LeL1FHbucaHnmRKuJh81p0HThYqDXF+H9+32LWwxqYw1r5RlfeqlWbXvAOmvfJHa
         jH0w==
X-Gm-Message-State: AOAM533B2os8QvMZ84DLeZRv+IgzduhaN7LWAL0ZbmBy+jmuLuFMrrG5
        qHITBfKHRygaailE2RgNiA==
X-Google-Smtp-Source: ABdhPJxvJk5Gfz+s8v5Gkz1xsf+wqIVtzcYiRafEuoMdOS5wIy1uW0boqjp6Ljc92wFmT+CR6tdUOA==
X-Received: by 2002:a92:9fcb:: with SMTP id z72mr5562602ilk.195.1596228463994;
        Fri, 31 Jul 2020 13:47:43 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id 142sm5498355ilc.40.2020.07.31.13.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 13:47:43 -0700 (PDT)
Received: (nullmailer pid 757897 invoked by uid 1000);
        Fri, 31 Jul 2020 20:47:42 -0000
Date:   Fri, 31 Jul 2020 14:47:42 -0600
From:   Rob Herring <robh@kernel.org>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Hartmut Knaack <knaack.h@gmx.de>, devicetree@vger.kernel.org,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        linux-iio@vger.kernel.org, Peter Rosin <peda@axentia.se>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] dt-bindings: iio: io-channel-mux: Fix compatible string
 in example code
Message-ID: <20200731204742.GA756942@bogus>
References: <20200727101605.24384-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727101605.24384-1-ceggers@arri.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 27 Jul 2020 12:16:05 +0200, Christian Eggers wrote:
> The correct compatible string is "gpio-mux" (see
> bindings/mux/gpio-mux.txt).
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Cc: stable@vger.kernel.org
> ---
>  .../devicetree/bindings/iio/multiplexer/io-channel-mux.txt      | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Added 'v4.13+' to stable tag and applied, thanks!
