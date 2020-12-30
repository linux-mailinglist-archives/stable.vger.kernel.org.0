Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C232E7A4B
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 16:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgL3P0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 10:26:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbgL3P0n (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Dec 2020 10:26:43 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49919C06179B;
        Wed, 30 Dec 2020 07:26:03 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id q22so22342416eja.2;
        Wed, 30 Dec 2020 07:26:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=6qSxpmMSH03FsmOJk6lrCHZxc7Tqo9FbYKTPYty80Wk=;
        b=aRoZmdLbDUKt5dk4sF0j87yGfpnLlW9y8bxpxebQceppT2/G2cDsTcvN9jdx+3vHaj
         Cd9d/F5R5L8TABJmBS15V6fk53yO+5YrenC3OtyjECiTfoqLX77+cCmSH2Q48GCpjgH5
         /GWGocQ0T1GyiEqMg9imbB1i+6yVQ0LPUhQ2XWC9TeiGDJpcovsZIGBFT925gRzoz3Ye
         JvfaVeT/sXsIMGar+ghTME/QqRhE+qtHi/JtC4lOMucD11tprnwGIE8Kwep+H9+EduP9
         jI98YlkEF2lyWyj6wmViJw8EHtTm+9wyXy6Tc7eDzhwmAgD6peW2NW5dRvyAUBkNwew0
         D4hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=6qSxpmMSH03FsmOJk6lrCHZxc7Tqo9FbYKTPYty80Wk=;
        b=FUo/hzwAANuLwS7UJLdKA/JB/WtTDEIxUL/U78M6fFbuyb7VELoK5R8EjF6LfZ2pzC
         YyXNs1XWBAiM8O9MbHwaSABRloAzB41kka4f7tWfAHxRnRKryt7wLnckxLj6iqrNjQEO
         0HayuWPLujApeAEJKkdEMUfZpheiCLQhTidqE1S+IRKTf8teLHE2qUH1Hygymraa+im3
         dH+eEmtyNBAiE4pe0+JJ5sb8IEm7xyyTnKvHX0BUhLQXRhoMOMGf0juE/0sN83DZpcjV
         BbHPvKDHnBQ8GHACczqKjbi8CIeLaqNg3VKUUsPred2R9n1OXXfzPy11lU4bF8lfOqma
         20mw==
X-Gm-Message-State: AOAM530F1UpAwUDr3XlWa7NCUTWbMfGoTpEqKGkCgGbBaCe1sC/QK/w3
        aq164wGPyBlc8K9UVhGbc+QJ/0Ux8/k=
X-Google-Smtp-Source: ABdhPJzHWXzPSPXMQCHYDaYJWhv03p/5vBZH3dAvdjym7a1xc9YAHKK359F2qASsFpOOhgvIWqBIdw==
X-Received: by 2002:a17:906:2695:: with SMTP id t21mr45700546ejc.287.1609341961692;
        Wed, 30 Dec 2020 07:26:01 -0800 (PST)
Received: from cl-fw-1.fritz.box (p200300d86714d50000b12fbf0e2de53d.dip0.t-ipconnect.de. [2003:d8:6714:d500:b1:2fbf:e2d:e53d])
        by smtp.gmail.com with ESMTPSA id e11sm19196464ejz.94.2020.12.30.07.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Dec 2020 07:26:01 -0800 (PST)
Message-ID: <d1b1e6b0e3af13f3756a34131ffb84df6a209ee0.camel@gmail.com>
Subject: sound
From:   Christian Labisch <clnetbox@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Date:   Wed, 30 Dec 2020 16:26:00 +0100
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello !

I could need your help ... I have tested the new kernel 5.10.3 and sound doesn't work with this
version.
Seems the new Intel audio drivers are the main reason. What can be done ? Do you have any ideas ?

Intel Catpt driver support is new ... This deprecates the previous Haswell SoC audio driver code
previously providing the audio capabilities.
And I am having a Haswell CPU -> Audio device: Intel Corporation Xeon E3-1200 v3/4th Gen Core
Processor HD Audio Controller (rev 06)

Regards,
Christian

