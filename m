Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825F03C6681
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 00:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhGLWug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 18:50:36 -0400
Received: from mx-lax3-3.ucr.edu ([169.235.156.38]:22630 "EHLO
        mx-lax3-3.ucr.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbhGLWug (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 18:50:36 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jul 2021 18:50:36 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1626130067; x=1657666067;
  h=mime-version:from:date:message-id:subject:to;
  bh=ifSIfnXd8bcmUUo9s673T74JcRVcrbFp1qn+wwKzU2I=;
  b=RqycgXBIzjcEeF/l56nKTJGDFs4WEIHYDViLbykHKqW6q92eD4Emf29n
   w98hH3Q/zOu0+9Z3f7rckMdpIBQMfHSkVi9vqZhrYo/0c072vVuBmIUws
   3Xy6MRKYHWJA1ArJ5B5C9EPTkU7aLbcZPpP7MCNOdyBkUUJ4XYXBhzrqM
   iuuii8anrONZprpdkiqgfWUObosGo3OPPbtX8IXYYbgmdBSwOKwihZkpX
   XHQn8bU1k19GuQwpAlIEVLs7aJGDFiKaBr7zIKhoPFL8Vguu7wuKOYkUB
   +FDSMnVhDbo65nNS9ePGZuvzrzXbW6mbvH9Txw2QryePtd53ZdexpQWe4
   w==;
IronPort-SDR: 14GmAKwFyOX3GafEcdhX0FnHNGVwyEEVa0L4LLdIv6UF4rQMaDbcq/Ugqw2WH8DLTUYzja+YYA
 VKdAvjsmWeCF7xA60iWgfiNF+aOVFZUejkyDoFQ5zKHLLtqw4TYNdt9M/xfGiDbNqpErSJDu6z
 4bm6EtqLOPkLpCgQbWQf4eopf7+VBFViMSN8fW6r7NOkgdstY1JKFEFayPPMgLg6no6FjE9krl
 rfsliAcbBl4lpU2t5f+QbjV395s77il+vTM8m3oCcURwyY9jgR8Pdk3ORY59zEtA1tok7+ZOpt
 GGQ=
X-IPAS-Result: =?us-ascii?q?A2FnCAD9w+xgdEjSVdFagQmBWYN4hTSRWoMnAZJ0hT+Bf?=
 =?us-ascii?q?AIJAQEBD0EEAQGHTwIlNAkOAgQBAQEBAwIDAQEBAQUBAQYBAQEBAQEFBAEBA?=
 =?us-ascii?q?hABb4UvRoI4IoQNEQR4DwImAiQSAQUBIzSCT4MInDyBBD2LMn8zgQGILQEJD?=
 =?us-ascii?q?YFjEn4qhwmCaIQhgimBS4sIgmQEg2ZVgROBP0BTAQEBnwedBQEGAoMKHJ40K?=
 =?us-ascii?q?4NjkVZCkFctlESBEZ9QhUkQI4E4ghUzGiV/BmeBTE8ZDod/lQ4kZwIGCgEBA?=
 =?us-ascii?q?wmMNQEB?=
IronPort-PHdr: A9a23:sfpvNhIf57YFaXi7fdmcuIlmWUAX0o4c3iYr45Yqw4hDbr6kt8y7e
 hCFvbM01hSZBs2bs6sC17OH9fi4GCQp2tWoiDg6aptCVhsI2409vjcLJ4q7M3D9N+PgdCcgH
 c5PBxdP9nC/NlVJSo6lPwWB6nK94iQPFRrhKAF7Ovr6GpLIj8Swyuu+54Dfbx9HiTajfb9+N
 gi6oRveusQVj4ZpN6I9xgfUrndSdOla2GdlKUiPkxrg48u74YJu/TlXt/897cBLTL/0f74/T
 bxWDTQmN3466cj2vhTdTgWB+2URXHwOnhVHHwbK4hf6XozssiThrepyxDOaPcztQr8qXzmp8
 rpmRwXpiCcDMD457X3Xh8lth69VvB6tuxpyyJPSbYqINvRxY7ndcMsVSmRBUMhfVDFPDJ2gY
 IYUE+oNIfxVo5Xhq1cSrxazAxSnCuP1yj9Pg3/7xaw10+U7HgHBwAMgH8wBsHLJp9r2M6cST
 P2+wa7HzDTCaPNWxCvx5JXKfx06vPGDQahwfdDPxkYyCgPIl1OdopHqMD2JzOoCqXSb7/Z+W
 uK1jW4qsx98rzivyMoohYfHiIEYx1HE+Ch93Is7KsC0RU5lbdOnE5ZduCOXOopqT84hTWxkp
 Sg0x6MEtJC7YSUG1okqygDZZveacIaI+gruWPiNLTp8nn5oe7Kyiwys/US91uHwTMu53EhMo
 yFYiNfDrGoN2AbW6sWfT/t9+Vqu1iiX2gDI7+FEPVg0la3GK5492rIwloQcsUDEHiLunUX5l
 q6WdkE99uiv9+Trf6zqppGeOoNqkA3+PaMumsuwAeQ8LAcCRXSU+eO51LH7/E35RqtFjuEun
 6XHrJzXId4Xq625DgNPzIov9gqzAy2k3dgGhXUHKUhKeBODj4jnIVHOJ/X4AO+wglWtlzdr2
 uzKMqDjD5jWM3jMjK3hcaxj5EFB1Qo/1cpf6I5MCrEdPPLzXVf8tMfEDhAjKAO0x/joBc5j1
 oMRR22PGLWVMKDMvl+S4OIgPe2MaJUSuDbnJPh2r8Lp2Hw0g1kQeYGx0J0YdWyiGfJnMwOVb
 D6khtYHDHdPtQM4ZPLlhUfEUjNJYXu2GaUm6XVzDo+6AYrdbp6ijabH3yqhGJBSIGdcBRTEC
 mvhfYGJc+kDZTjUIcJ7lDEAE7+7RNwPzxar4T/7wr1sLufSsh8fqNq3xMpy+rWKyjkv/iYyA
 siAhTLeB1pol38FEmdllJt0plZwnw/r7A==
IronPort-HdrOrdr: A9a23:gwxjUqMw6cMgsMBcT4T155DYdb4zR+YMi2TDiHoddfUFSKalfp
 6V98jztSWUtN9xYgBYpTnkAsW9qBznhPlICOUqTNKftWrdyQmVxeNZnPPfKlTbckWQmJ8/6U
 p5SchD4bXLfCNHZK3BkW+F+rgbsb26GZST9J3jJjpWPHRXQpAlyz08JheQE0VwSgUDL4E+Do
 Cg6s1OoCflUWgLb+ygb0N1FNTrlpnurtbLcBQGDxko5E2lljWz8oP3FBCew1M3Ty5P+7E/6m
 LI+jaJrJlLi8vLhyM06lWjpqi+2eGRvOerPfb8/fT9/w+cwjpBZ+xaKs2/VX4O0a2SAW0R4a
 XxSiEbTrVOAkPqDxyISCTWqnbdORYVmgzfIAyj8AneSfKQfkNFNyMGv/MsTifk
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.84,235,1620716400"; 
   d="scan'208";a="56823109"
Received: from mail-ot1-f72.google.com ([209.85.210.72])
  by smtp-lax3-3.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jul 2021 15:40:40 -0700
Received: by mail-ot1-f72.google.com with SMTP id l8-20020a0568301548b02904ad8104e567so14177350otp.20
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 15:40:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ifSIfnXd8bcmUUo9s673T74JcRVcrbFp1qn+wwKzU2I=;
        b=cCRzaILkpUeOaSM1SvGEpVgLwdzI4/nDtbPjjUM5FHn9UaH4cj+lIbup89yWJADogD
         8LZeRTr/MYHAPgG22K2m/fPLQX30jBWCMQsZXcsJeoRfq0jxJ8SGKNJy1rIK2RItQYhv
         qW3qjmAHJbVIft91vNinQa5DtwLGAVtzx6Rulegr2WjheqX7mGOHGbJ2fQlmXcErJqJ1
         /OSk96hx4UxecX7LgfwGXGsMXRuIgYfByYAES0uAwysp/w1GVUPwxvsWx40mD/pzqmsD
         rEasOXAJSvUQspuQAke9s9kvLZUHPD8fR4Ed14rVia4PS4KgPZ1VPxZKX7DOIr93FxyU
         vbNg==
X-Gm-Message-State: AOAM5334xJ1KEsMrzR4CpAjbg33oSxq+NAQAFTeTiveicdRA4lW1P1k0
        HgsiMd5erYz7Ws41uzeXnleYW+xZkR8TNuulPaLdMS40sTAMAP0VRCTLvXlitAFsUefvbo9SVbb
        D/ZsahrRVJGBUPS0ClssdwBNiKUeRhf4aOg==
X-Received: by 2002:a05:6808:485:: with SMTP id z5mr779654oid.173.1626129639556;
        Mon, 12 Jul 2021 15:40:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZfGqHGQmRnC5RP4bUAOLDwdo88/vNQTwKvTmt2dHYkvb/X7zkHNffTLqVK0CNQp9UGHGV5fGxZhg3/cLae1Y=
X-Received: by 2002:a05:6808:485:: with SMTP id z5mr779640oid.173.1626129639340;
 Mon, 12 Jul 2021 15:40:39 -0700 (PDT)
MIME-Version: 1.0
From:   Xiaochen Zou <xzou017@ucr.edu>
Date:   Mon, 12 Jul 2021 15:40:46 -0700
Message-ID: <CAE1SXrtrg4CrWg_rZLUHqWWFHkGnK5Ez0PExJq8-A9d5NjE_-w@mail.gmail.com>
Subject: Use-after-free access in j1939_session_deactivate
To:     kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
It looks like there are multiple use-after-free accesses in
j1939_session_deactivate()

static bool j1939_session_deactivate(struct j1939_session *session)
{
bool active;

j1939_session_list_lock(session->priv);
active = j1939_session_deactivate_locked(session); //session can be freed inside
j1939_session_list_unlock(session->priv); // It causes UAF read and write

return active;
}

session can be freed by
j1939_session_deactivate_locked->j1939_session_put->__j1939_session_release->j1939_session_destroy->kfree.
Therefore it makes the unlock function perform UAF access.


Best,
Xiaochen Zou
Department of Computer Science & Engineering
University of California, Riverside
