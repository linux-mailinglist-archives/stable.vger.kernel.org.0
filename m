Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8755018E2DA
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 17:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbgCUQNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Mar 2020 12:13:50 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:54617 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727128AbgCUQNu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Mar 2020 12:13:50 -0400
Received: by mail-pj1-f66.google.com with SMTP id np9so3918530pjb.4
        for <stable@vger.kernel.org>; Sat, 21 Mar 2020 09:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:from:subject:autocrypt:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=+CUkyBqHze2lJWR+lVDUM/dLODYNWahDsgeGK4K3ECk=;
        b=tTvV8T1rGACFbHetx7szP/z585vS0I/fIWSbzWQT/1ZSATqpYNV0mjlZZfwnapUBZ2
         5N2AXOHrJWKxsrk/zlkVl6qIvS3bHhdPOrHuQj3H72ZR57EjRzF8/otRbvsLsXFdskHR
         7ttDrAyAbwG7iF8l2JZ74zthhVsMzbZeJ4GDHVp56st56J3X/dfrW6MuicbINPdRk0F0
         exLy6HLwZApJJhKgueQFcEEPo3+53lADQfN9MhF09ipPzRl46zu+5zfbWQBUz+ACuHgJ
         HVWZHTfM8ssyyeOBYK7dBXjRBnRkFVj9C7M4BEjPWmI1Mm9SWXljKoQoVx5amzlSl9n0
         WHcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:from:subject:autocrypt:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=+CUkyBqHze2lJWR+lVDUM/dLODYNWahDsgeGK4K3ECk=;
        b=KNj0LTjuzkYx0tD4Ge/SfD2LmR+G25kLDP0Hza1l53ylamkBF8MYUUFnDFCFhyNito
         pdOIRcaqG8ETzjufDSxT0ROB+3uszS+ZLQvif9cfqwhN7u8MNOIQ/oDQLKrvCxeuyFzO
         mUKcUytH7//VTPwIA9LvjWc1CHKUGr5jxGRWlUNpwlrKk61jBS8JTA4jfRh9adeBqhL0
         scFLzw5pRFAtNxdrC6iaKb85Ru/iczVnPBfuI8leDkOAzkDO0NCWcA0Ui0oz51+h76Zr
         E1jm7O1Aqp0eXM1vNd+tniGA1/sbRicaLA1nAkl/YgVjD19cJM0YPH/UiiIx07THaBA/
         Ob9Q==
X-Gm-Message-State: ANhLgQ3ketVdKW/XWuG/IOhmB7FIFZKbMuC2rTgWw2V0vF3KIgHEahu2
        VZT9csyR77ZrMIaov9qHwWrdc8TV
X-Google-Smtp-Source: ADFU+vvFdPnLUzM7Q9LdufK4YxgwOth/kJcTUuTSss2seC8xY8zBhedzWoFuwfAjZ3rAgUIFduFXxA==
X-Received: by 2002:a17:902:8f94:: with SMTP id z20mr14322830plo.62.1584807228899;
        Sat, 21 Mar 2020 09:13:48 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k1sm8094485pgg.56.2020.03.21.09.13.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Mar 2020 09:13:48 -0700 (PDT)
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Handling of patches missing in stable releases based on Fixes: tags
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <ea9275e1-728f-9b12-c787-7109985bf7c3@roeck-us.net>
Date:   Sat, 21 Mar 2020 09:13:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

we now have a script that identifies patches in stable releases which were
later fixed upstream, but the fix was not applied to the respective stable
releases. We identify such patches based on Fixes: tags in the upstream
kernel.

Example: Upstream commit c54c7374ff4 ("drm/dp_mst: Skip validating ports
during destruction, just ref") was applied to v4.4.y as commit 05d994f68019.
It was later reverted upstream with commit 9765635b307, but the revert has
(at least not yet) found its way into v4.4.y.

This is an easy example, where the revert should (or at least I think it
should) be applied to v4.4.y (and possibly to later kernels - I didn't check).
A more tricky patch is commit 3ef240eaff36 ("futex: Prevent exit livelock")
in v5.4.y, which was later fixed upstream with commit 51bfb1d11d6 ("futex:
Fix kernel-doc notation warning"). I am not entirely sure what to do with
that, given that it only fixes documentation (though that may of course also
be valuable).

How should we handle this ? Would it be ok to send half-automated requests
to the stable mailing list, for example with basic test results ?

Thanks,
Guenter
