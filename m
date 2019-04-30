Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5C30FAEC
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 16:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfD3OBg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 10:01:36 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:40128 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbfD3OBg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 10:01:36 -0400
Received: by mail-pf1-f169.google.com with SMTP id u17so3139238pfn.7;
        Tue, 30 Apr 2019 07:01:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=0AILrt3kKWWbkhF709FLv0WUXE4if3LBxPh+WN7C8vc=;
        b=GZH4JB3ZiiBwlmyGahUXFi8CEiz62Mzol3uZPLQ6J2AJ5Oe0ePwPcnhvBFb0Azby4N
         jEqnDbcODK7l2gI4t2YGfmh0zu1Ml/oVwa0jd42XO7R843PNkphUM2VVPMTqmzwfOGm4
         31CeZHXhtsz8CtSnj0P/DOt/NxkrblwWzTNjgGWUglTTyd/LnQEBSnoT5PzqS9GsSSJf
         L9IdLbdcxlUHUqwWedAVECYpfRap0GdnUZGvnVXsQy+M6WbyQqxt775CbA2GwYhbnQ+M
         Mpn38iuNmhpWCSKj2zJ+rI9prPPRgx8/VlgDx2IAzLvGGBv2b/nv6bLPF73nNZQ5Zgj3
         m9Ww==
X-Gm-Message-State: APjAAAV/7ldEl7coSsfwl6U1pmDZ4+8xp7xX72xMJg7sflwZ6niFTUHb
        mvxXK1Vogt2oYENn3LCyrYPZoaEhXAM=
X-Google-Smtp-Source: APXvYqyT+6TVkiY/N6jD1OysD3aQ7iGlOEtsLJwAACZ4nU9LgHBi96qtDXXdGOp4QN8SrAsY0DPDew==
X-Received: by 2002:a63:3dca:: with SMTP id k193mr66883987pga.146.1556632894048;
        Tue, 30 Apr 2019 07:01:34 -0700 (PDT)
Received: from asus.site ([2601:647:4000:5dd1:a41e:80b4:deb3:fb66])
        by smtp.gmail.com with ESMTPSA id t5sm47010653pfh.141.2019.04.30.07.01.31
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 07:01:31 -0700 (PDT)
Subject: Re: [PATCH] RDMA/srp: Accept again source addresses that do not have
 a port number
To:     Laurence Oberman <loberman@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        stable@vger.kernel.org
References: <20190321203428.128471-1-bvanassche@acm.org>
 <bae975c8d5a4e256ba2987e5429b15333c1da0af.camel@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Openpgp: preference=signencrypt
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <ff66957f-d288-8d7d-edcb-fab04cf11265@acm.org>
Date:   Tue, 30 Apr 2019 07:01:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <bae975c8d5a4e256ba2987e5429b15333c1da0af.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/26/19 8:37 AM, Laurence Oberman wrote:
> This looks orrect to me, will test and report back.

Hi Laurence,

As you probably know the merge window will open soon. Do you still plan
to share test results?

Thanks,

Bart.
