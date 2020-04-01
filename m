Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B06119ADFA
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 16:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732749AbgDAOed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 10:34:33 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41768 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732807AbgDAOed (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 10:34:33 -0400
Received: by mail-qk1-f196.google.com with SMTP id q188so15672qke.8;
        Wed, 01 Apr 2020 07:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=9uAYoKMGE9PgfUp+bxUEGlyVqoWBakozXuhgR9OnmJo=;
        b=fK3mLwVpmvWNMNQZIfkorXHF76+WwmMryp1OHVwlSl1O85sIrcNart6MFCEiiWbEhs
         aytFZnssPwGjnbo94olpF9MfsbX9J1xCSFt2BrENTSHN4vC155UVCk720aGx5WASi60E
         TscGO7swoEZI/8F5BSwrz7MOLDmVktr79lLuamR8edNuRVAyrDm5YX5hsjDS05joeTQ7
         YMGTWZNOMgdh7V3Z4DD+luIQEbBk7y6QiTveIR8T3eUl180TbMuKjhcJ5/cp8wFnNNVl
         xQMfXJ4EMnv917YC7y0dA1ifpMpJSwYENyT3lwQbBIyn6JsLAvlHnPo2sRxtP0UW7cbf
         1OwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=9uAYoKMGE9PgfUp+bxUEGlyVqoWBakozXuhgR9OnmJo=;
        b=Kjf06fnK2Ph3EFyNRO71+w02LEWXoj4rFkVyIgITLMD1GnJTZoixT/BfED0X0T08g+
         eP7NF9YrGHHGdhpMWYdApn4PWvlE+85+YaOeIzBka/vTtgweYtxDcHCBpnbj2UIVgcol
         mUeuNdT9asMv+3pL3g42A2Dy2HAA/HqnhEDTOdyAi0zxi6qGteyEgOyCiyv+SStd3oKC
         UPHvYIaJjSGXPvD0+sRGJC8sx2wmZfT/wmKPtwEqu1eglCodRls9tG90xasE6qwIdQPK
         +PC+L7B6j5RLNZTwJwi3EyGDdvUlKon4+9hmZoZlpLRAfolbg9iixT3uy+jyzusHmD5Y
         im+A==
X-Gm-Message-State: ANhLgQ1RBgD+7OsM3a38Efm3xy8FVjIgDIcVCcVQaCF4m4hFOq6ujd71
        IQAu4Q6REU4DvHeTp/e43MA=
X-Google-Smtp-Source: ADFU+vtGOEpjkKIYtf8jHd+3VJ7c6eIOIuhNahnR88YvKxOs9svqhhyOqpuGA3wbHqbp6skYm77mJg==
X-Received: by 2002:a37:812:: with SMTP id 18mr9637047qki.139.1585751670754;
        Wed, 01 Apr 2020 07:34:30 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id 199sm1505085qkm.7.2020.04.01.07.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 07:34:29 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 14EAD409A3; Wed,  1 Apr 2020 11:34:27 -0300 (-03)
Date:   Wed, 1 Apr 2020 11:34:27 -0300
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>
Subject: Re: [PATCH 5.6 00/23] 5.6.1-rc1 review
Message-ID: <20200401143427.GB12534@kernel.org>
References: <20200331085308.098696461@linuxfoundation.org>
 <CA+G9fYsZjmf34pQT1DeLN_DDwvxCWEkbzBfF0q2VERHb25dfZQ@mail.gmail.com>
 <CAHk-=whyW9TXfYxyxUW6hP9e0A=5MnOHrTarr4_k0hiddxq69Q@mail.gmail.com>
 <20200331192949.GN9917@kernel.org>
 <CAEUSe7_f8m0dLQT1jdU+87fNThnxMKuoGJkFuGpbT4OmpmE4iA@mail.gmail.com>
 <20200401124037.GA12534@kernel.org>
 <CAEUSe7-ercqbofx93m-d0RNW_dQqr1U7F7JYQ5X81CHSkq4KDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEUSe7-ercqbofx93m-d0RNW_dQqr1U7F7JYQ5X81CHSkq4KDw@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Wed, Apr 01, 2020 at 07:45:53AM -0600, Daniel Díaz escreveu:
> This worked on top of torvalds/master and linux-stable-rc/linux-5.6.y.
> 
> Thanks and greetings!

Thanks, I'm taking this as a:

Tested-by: Daniel Díaz <daniel.diaz@linaro.org>

Ok?

- Arnaldo
 
> Daniel Díaz
> daniel.diaz@linaro.org
